module din.api;

interface Notifier {
	void send(Notification toSend) @safe;
}
/**
 * Struct containing notification data. Fill in as much as possible for best
 * results. Note that not all services are guaranteed to support all fields.
 */
struct Notification {
	import std.datetime : SysTime;
	///Title for sent notification. Typically displayed along with the message body.
	string title;
	string appTitle;
	string message;
	string url;
	byte priority = -1;
	SysTime time;
}
