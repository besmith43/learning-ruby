App.message = App.cable.subscriptions.create "MessageChannel",
  connected: ->
    @streamCurrentMessage()

  collection: ->
    $("[data-channel='rooms']")

  streamCurrentMessage: ->
    if roomId = @collection().data('room-id')
      @perform 'follow', room_id: roomId
    else
      @perform 'unfollow'

  received: (data) ->
    @collection().append(data.message)
