module din.notifiers.multi;

import din.api;

/**
 * Interface for preparing notifiers and sending notifications to multiple
 * services simultaneously.
 */
class MultiNotifier : Notifier {
	private Notifier[] notifiers;
	/**
	 * Sends a notification to all registered notification services and their
	 * targets.
	 * Params: toSend = The notification that will be sent out
	 */
	public void send(Notification toSend) @safe {
		foreach (notifier; notifiers) {
			notifier.send(toSend);
		}
	}
	/**
	 * Registers a notification service with this instance.
	 * Params:
	 *  notifier = An instance of the service
	 */
	public void add(Notifier notifier) @safe {
		notifiers ~= notifier;
	}
}
