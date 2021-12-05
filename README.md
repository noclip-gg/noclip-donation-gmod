# noclip-gmod
Gmod implementation of the Noclip Donation Panel


## Basic docs

### Functions

```
[SERVER] NoClip.Store.Core.Check()
```

### Description
Has the server check against the API for any new purchases. Calls the `NoClipStoreCheck` hook internally.


```
[SERVER] NoClip.Store.Core.Error(error)
```

### Description
Register an internal error with the store. Currently this just prints a message to console, but could be used for persistent logging errors in the future.

### Arguments
String `error` - The error message.


```
[SERVER] NoClip.Store.Core.Notification(msg, ply)
```

### Description
Send a notification to a client. This will respect the queue. `ply` can also be `player.GetAll()` or a table of players with the intent of mass sending the message.

### Arguments
String `msg` - The message to send.
Entity/Table `ply` - The player(s) to send the message to.


```
[SERVER] NoClip.Store.Core.EventProcess(data)
```

### Description
Used to process an event from the data given by the API. If you want to process custom actions on an event, use `NoClipStorePostEventProcess` instead.

### Arguments
Table `data` - The data given by the API.


```
[SERVER] NoClip.Store.Core.EventMarkProcessed(eventID)
```

### Description
Used to mark an event as processed with the API. Removing it from the queue.

### Arguments
String `eventID` - The unique ID for this event.



```
[CLIENT] NoClip.Store.UI.Notification(msg)
```

### Description
Render a new notification to the client. This function does not respect the queue.

### Arguments
String `msg` - The message to show.


```
[CLIENT] NoClip.Store.Notifications.Next()
```

### Description
Have the next notification in the queue show. If a notification is already active, this will silently fail.



## Hooks

```
[SERVER] NoClipStoreCheck
```

#### Description
Called whenever the server checks for new purchases.

#### Arguments
Table `data` - The raw response from the API, converted from JSON to a table.


```
[SERVER] NoClipStorePreEventProcess
```

#### Description
Called whenever an event is about to be processed. Returning `false` will prevent this event from processing. The even however, will still be attempted to process again on next check. In order to prevent this, you will need to mark the event as processed yourself. You can do this by calling `YetImplementedFunction` with the eventID.

#### Arguments
Int `eventID` - The unique ID for this event.
Table `data` - All of the data received from the API for this event.


```
[SERVER] NoClipStorePostEventProcess
```

#### Description
Called after an event has been processed and all actions are complete. You can use this to do extra actions.

#### Arguments
Int `eventID` - The unique ID for this event.
Table `data` - All of the data received from the API for this event.