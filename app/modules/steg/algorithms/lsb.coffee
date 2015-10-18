define ->

  class LSBAlgorithm

    channels:
      r: 0
      g: 1
      b: 2

    masks:
      one: 1
      zero: 254

    lengthBitSize: 16
    byteSize: 8

    constructor: (image, channel) ->
      @canvas = document.createElement('canvas')
      @ctx = @canvas.getContext('2d')

      @canvas.width = @width = image.width
      @canvas.height = @height = image.height

      @curWidth = 0
      @curHeight = 0
      @curChannel = @channels[channel]

      @ctx.drawImage(image, 0, 0)
      @imgd = @ctx.getImageData(0, 0, @width, @height)
      @pixels = @imgd.data

    hideText: (text) ->
      @_putBinaryValue(@_binValue(text.length, @lengthBitSize))
      for ch in text
        @_putBinaryValue(@_byteValue(ch.charCodeAt()))

    revealText: ->
      [@curWidth, @curHeight] = [0, 0]
      text = ""
      length = parseInt(@_readBits(@lengthBitSize), 2)
      for i in [0...length]
        text += String.fromCharCode(parseInt(@_readByte(), 2))
      text

    getImageUrl: ->
      @ctx.putImageData(@imgd, 0, 0)
      return @canvas.toDataURL()

    getImage: ->
      @ctx.putImageData(@imgd, 0, 0)
      image = new Image()
      image.src = @canvas.toDataURL()
      image

    _putBinaryValue: (bits) ->
      for c in bits
        startIndex = @_getCurrentIndex()
        pixel = @_getPixel(startIndex)

        if parseInt(c, 10) is 1
          pixel[@curChannel] = pixel[@curChannel] | @masks.one
        else
          pixel[@curChannel] = pixel[@curChannel] & @masks.zero

        @_setPixel(startIndex, pixel)
        @_nextPixel()

    _readByte: ->
      @_readBits(@byteSize)

    _readBits: (nb) ->
      bits = ""
      for i in [0...nb]
        bits += @_readBit()
      bits

    _readBit: ->
      val = @_getPixel(@_getCurrentIndex())[@curChannel]
      val = parseInt(val, 10) & @masks.one
      @_nextPixel()
      if val > 0 then '1' else '0'

    _nextPixel: (step = 1) ->
      if (@curWidth + step) < @width
        @curWidth += step
      else if (@curHeight + 1) < @height
        @curWidth = (@curWidth + step) - @width
        @curHeight += 1
      else if (@curHeight + 1) >= @height
        throw new Error('Image filled')

    _getPixel: (startIndex) ->
      for i in [startIndex...startIndex+4]
        @pixels[i]

    _setPixel: (startIndex, pixel) ->
      j = 0
      for i in [startIndex...startIndex+4]
        @pixels[i] = pixel[j++]

    _getCurrentIndex: ->
      (@curHeight * (@width * 4)) + (@curWidth * 4)

    _binValue: (val, bitsize) ->
      binVal = val.toString(2)
      if binVal.length > bitsize
        throw new Error('Bit size overflow')
      while binVal.length < bitsize
        binVal = '0' + binVal
      binVal

    _byteValue: (val) ->
      @_binValue(val, @byteSize)
