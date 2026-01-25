// src/extension/logging/layer.rs
//
// Tracing layer that sends log events to Arma via extension callbacks.

use arma_rs::Context;
use tracing::{Level, Subscriber};
use tracing_subscriber::Layer;
use tracing_subscriber::layer::Context as LayerContext;

use super::LOG_LEVEL;

/// Tracing layer that forwards events to Arma.
pub struct ArmaLayer {
    context: Context,
}

impl ArmaLayer {
    pub fn new(context: Context) -> Self {
        Self { context }
    }

    fn should_log(&self, level: &Level) -> bool {
        LOG_LEVEL
            .read()
            .map(|current| level <= &*current)
            .unwrap_or(true)
    }
}

impl<S> Layer<S> for ArmaLayer
where
    S: Subscriber,
{
    fn on_event(&self, event: &tracing::Event<'_>, _ctx: LayerContext<'_, S>) {
        let metadata = event.metadata();

        if !self.should_log(metadata.level()) {
            return;
        }

        let level = match *metadata.level() {
            Level::ERROR => "ERROR",
            Level::WARN => "WARN",
            Level::INFO => "INFO",
            Level::DEBUG => "DEBUG",
            Level::TRACE => "TRACE",
        };

        let target = metadata.target();

        let mut message = String::new();
        let mut visitor = MessageVisitor(&mut message);
        event.record(&mut visitor);

        let _ = self.context.callback_data(
            "skua_ext_log",
            target,
            Some(vec![level.to_string(), message]),
        );
    }
}

/// Visitor to extract message and fields from tracing events.
struct MessageVisitor<'a>(&'a mut String);

impl<'a> tracing::field::Visit for MessageVisitor<'a> {
    fn record_debug(&mut self, field: &tracing::field::Field, value: &dyn std::fmt::Debug) {
        if field.name() == "message" {
            *self.0 = format!("{:?}", value);
        } else {
            if !self.0.is_empty() {
                self.0.push_str(", ");
            }
            self.0.push_str(&format!("{} = {:?}", field.name(), value));
        }
    }
}

/// Initialize the Arma tracing layer.
///
/// Call this once during extension initialization with the extension context.
pub fn init(context: Context) {
    use tracing_subscriber::layer::SubscriberExt;
    use tracing_subscriber::util::SubscriberInitExt;

    let layer = ArmaLayer::new(context);
    let subscriber = tracing_subscriber::registry().with(layer);

    if let Err(e) = subscriber.try_init() {
        eprintln!("Failed to initialize tracing subscriber: {}", e);
    }
}
