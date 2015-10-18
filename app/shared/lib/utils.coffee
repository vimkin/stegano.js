define [
  'Q'
], (Q) ->

  {
    readFileURL: (input) ->
      defer = Q.defer()

      if not input.files
        defer.reject()
        return

      reader = new FileReader()
      reader.onload = (e) ->
        defer.resolve(e.target.result)

      reader.readAsDataURL(input.files[0])

      defer.promise

    createImageFromUrl: (url) ->
      defer = Q.defer()

      if not url
        defer.reject()
        return

      image = new Image()
      image.onload = ->
        defer.resolve(image)
      image.src = url

      defer.promise

    getDividend: (dividend, divider) ->
      dividend++ while dividend % divider
      dividend
  }