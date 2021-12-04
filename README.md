# noclip-gmod
Gmod implementation of the Noclip Donation Panel


## Basic docs
### Functions
```
NoClip.Store.Core.Check()
```
### Description
Has the server check against the API for any new purchases. Calls the `NoClipStoreCheck` hook internally.

### Hooks
```
NoClipStoreCheck
```
#### Description
Called whenever the server checks for new purchases.

#### Arguments
Table `data` - The raw response from the API, converted from JSON to a table.

```
NoClipStorePreEventProcess
```
#### Description
Called whenever an event is about to be processed. Returning `false` will prevent this event from processing. The even however, will still be attempted to process again on next check. In order to prevent this, you will need to mark the event as processed yourself. You can do this by calling `YetImplementedFunction` with the eventID.

#### Arguments
Int `eventID` - The unique ID for this event.
Table `data` - All of the data received from the API for this event.