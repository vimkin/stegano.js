define (require) ->

  _ = require('underscore')
  utils = require('shared/lib/utils')
  seedrandom = require('seedrandom')
  DCT = require('./dct')

  class KohaJaoAlgorithm

    channels:
      r: 0
      g: 1
      b: 2

    blockSize: 8
    lengthBitSize: 16
    byteSize: 8

    constructor: (image, channel, factor, seed) ->
      @factor = factor
      @rng = seedrandom(seed)
      @canvas = document.createElement('canvas')
      @ctx = @canvas.getContext('2d')

      @canvas.width = @width = image.width
      @canvas.height = @height = image.height
      @mWidth = utils.getDividend(@width, @blockSize)
      @mHeight = utils.getDividend(@height, @blockSize)

      @curWidth = 0
      @curHeight = 0
      @curChannel = @channels[channel]

      @ctx.drawImage(image, 0, 0)
      @imgd = @ctx.getImageData(0, 0, @width, @height)
      @matrix = @_transformToMatrix(@imgd.data)
      @_completeImage(@matrix)

    hideText: (text) ->
      console.log '#hideText'
      @_putBinaryValue(@_binValue(text.length, @lengthBitSize))
      for ch in text
        @_putBinaryValue(@_byteValue(ch.charCodeAt()))

      # Set imaged
      @_setImaged(@matrix)
      console.log '#hideText finished'

    revealText: ->
      console.log '#revealText'
      [@curWidth, @curHeight] = [0, 0]
      @rng = seedrandom('5')
      text = ""
      length = parseInt(@_readBits(@lengthBitSize), 2)
      for i in [0...length]
        text += String.fromCharCode(parseInt(@_readByte(), 2))
      text

    _setImaged: (matrix) ->
      flatten = _.flattenDeep(matrix)
      @imgd = @ctx.createImageData(@mWidth, @mHeight)

      for i in [0...@imgd.data.length] by 4
        @imgd.data[i] = flatten[i]
        @imgd.data[i + 1] = flatten[i + 1]
        @imgd.data[i + 2] = flatten[i + 2]
        @imgd.data[i + 3] = flatten[i + 3]

    _putBinaryValue: (bits) ->
      console.log '#putBinaryValue'
      for c in bits
        # Get DCT block
        dct = DCT.dct(@_getBlock())

        # Get two coefficients
        cell1 = null
        cell2 = null
        [cell1, cell2] = @_getRandomCells()
        coef1 = dct[cell1.r][cell1.c]
        coef2 = dct[cell2.r][cell2.c]

        # Get solution related on bit is 0 or 1
        # It will return same coefficients if solution is ok
        bit = parseInt(c, 10)
        solution = @_solveEquation(coef1, coef2, @factor, bit)

        # Set coefficient
        dct[cell1.r][cell1.c] = solution.coef1
        dct[cell2.r][cell2.c] = solution.coef2

        # Set inverse DCT block to pixels matrix
        inverse = DCT.dct(dct, {inverse: true})
        @_setBlock(inverse)

        # Go to next block
        @_nextBlock()

    _readByte: ->
      @_readBits(@byteSize)

    _readBits: (nb) ->
      bits = ""
      for i in [0...nb]
        bits += @_readBit()
      bits

    _readBit: ->
      # Get DCT block
      dct = DCT.dct(@_getBlock())

      # Get two coefficients
      cell1 = null
      cell2 = null
      [cell1, cell2] = @_getRandomCells()
      coef1 = dct[cell1.r][cell1.c]
      coef2 = dct[cell2.r][cell2.c]

      # Go to next block
      @_nextBlock()

      # Return bit
      if (Math.abs(coef1) - Math.abs(coef2) < -@factor) then '1' else '0'

    _solveEquation: (coef1, coef2, factor, bit) ->
      c1 = coef1
      c2 = coef2

      if bit is 1
        while not(Math.abs(c1) - Math.abs(c2) < -(factor + 5))
          c2-- if Math.sign(c2) is -1
          c2++ if Math.sign(c2) is 1 or Math.sign(c2) is 0
      else if bit is 0
        while not(Math.abs(c1) - Math.abs(c2) > (factor + 5))
          c1-- if Math.sign(c1) is -1
          c1++ if Math.sign(c1) is 1 or Math.sign(c1) is 0

      return {
        coef1: c1
        coef2: c2
      }

    _getRandomCells: ->
      cell1 = @_getRandomCell()
      cell2 = @_getRandomCell()
      while cell2.r is cell1.r and cell2.c is cell1.c
        cell2 = @_getRandomCell()
      return [cell1, cell2]

    _getRandomCell: ->
      number = Math.floor(@rng() * 100 + 1) % 63
      {
        r: Math.floor(number / @blockSize)
        c: number % @blockSize
      }

    _getBlock: ->
      for i in [@curHeight...(@curHeight + @blockSize)]
        for j in [@curWidth...(@curWidth + @blockSize)]
          @matrix[i][j][@curChannel] - 128

    # Modify current matrix by reference
    _setBlock: (matrix) ->
      k = 0
      l = 0
      for i in [@curHeight...(@curHeight + @blockSize)]
        for j in [@curWidth...(@curWidth + @blockSize)]
          @matrix[i][j][@curChannel] = matrix[k][l] + 128
          l++
        l = 0
        k++

    _nextBlock: ->
      if (@curWidth + @blockSize) < @mWidth
        @curWidth += @blockSize
      else if (@curHeight + @blockSize) < @mHeight
        @curWidth = 0
        @curHeight += @blockSize
      else if (@curHeight + @blockSize) >= @mHeight
        throw new Error('Image filled')

    _binValue: (val, bitsize) ->
      binVal = val.toString(2)
      if binVal.length > bitsize
        throw new Error('Bit size overflow')
      while binVal.length < bitsize
        binVal = '0' + binVal
      binVal

    _byteValue: (val) ->
      @_binValue(val, @byteSize)

    # Complete image if width or height doesn't divide to 8
    _completeImage: (matrix, options={}) ->
      console.log '#_completeImage'
      return unless @width % @blockSize and @height % @blockSize

      wDif = @mWidth - @width
      hDif = @mHeight - @height

      # Cloning last value N times to fit 8x8 blocks
      for i in [0...@height]
        for j in [0...wDif]
          matrix[i][@width + j] = _.clone(matrix[i][@width + j - 1])

      # Cloning last row N times to fit 8x8 blocks
      for i in [0...hDif]
        matrix[@height + i] = _.cloneDeep(matrix[@height + i - 1])

      matrix

    _transformToMatrix: (pixels) ->
      matrix = _.chain(pixels)
        .chunk(4)
        .chunk(@width)
        .value()
      matrix

    getImageUrl: ->
      canvas = document.createElement('canvas')
      ctx = canvas.getContext('2d')
      canvas.width = @mWidth
      canvas.height = @mHeight

      ctx.putImageData(@imgd, 0, 0)
      return canvas.toDataURL()

    getImage: ->
      @ctx.putImageData(@imgd, 0, 0)
      image = new Image()
      image.src = @canvas.toDataURL()
      image
