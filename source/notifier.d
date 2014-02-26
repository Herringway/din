module notifier;
private import pushover;
private import notifymyandroid;
private import std.exception;
private import std.datetime;

enum pushService { Pushover, NotifyMyAndroid };
class Din {
	Notifier[] notifiers;

	public void send(notification toSend) {
		foreach (notifier; notifiers)
			notifier.send(toSend);
	}
	public void addNotifier(pushService service, string APIKey, string[] targets) {
		auto notifier = createNotifier(service, targets);
		notifier.APIKey = APIKey;
		notifiers ~= notifier;
	}
	public void addNotifier(pushService service, string[] targets) {
		auto notifier = createNotifier(service, targets);
		if (notifier.needsAPIKey)
			throw new Exception("Unable to create instance of this notifier without an API Key");
		notifiers ~= notifier;
	}
	private Notifier createNotifier(pushService service, string[] targets) {
		if (targets.length == 0)
			throw new Exception("No targets specified");
		Notifier notifier;
		switch (service) {
			case pushService.Pushover: notifier = new Pushover; break;
			case pushService.NotifyMyAndroid: notifier = new NotifyMyAndroid; break;
			default: throw new Exception("Unsupported service");
		}
		notifier.setTargets(targets);
		return notifier;
	}
	deprecated {
		string[][pushService] targetIDs;
		string[pushService] APIKeys;
		string apptitle;
		public void send(string title, string message) {
			Notifier[] tmpNotifiers;
			with (pushService) {
				if (Pushover in targetIDs) {
					auto PushoverNotifier = createNotifier(Pushover, targetIDs[Pushover]);
					PushoverNotifier.APIKey = APIKeys[Pushover];
					tmpNotifiers ~= PushoverNotifier;
				}
				if (NotifyMyAndroid in targetIDs)
					tmpNotifiers ~= createNotifier(NotifyMyAndroid, targetIDs[NotifyMyAndroid]);
			}
			auto toSend = notification();
			toSend.message = message;
			toSend.title = title;
			toSend.apptitle = apptitle;
			foreach (notifier; tmpNotifiers)
				notifier.send(toSend);
		}
		public void setAPIKey(pushService service, string id) {
			APIKeys[service] = id;
		}
		public void addDeviceKey(pushService service, string key) {
			targetIDs[service] ~= key;
		}
	}
}
interface Notifier {
	void send(notification toSend);
	void setTargets(string[] targets);
	@property bool needsAPIKey();
	@property string APIKey(string key);
}
struct notification {
	string title;
	string apptitle;
	string message;
	string url;
	byte priority = 0;
	SysTime time;
}