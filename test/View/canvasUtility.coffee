fs = require('fs')

class CanvasUtility
  @save: (canvasElement, filename) ->
    fs.writeFileSync(filename, CanvasUtility.convertBuffer(canvasElement))

  @compare: (canvasElement, filename) ->
    src = CanvasUtility.convertBuffer(canvasElement)
    dist = fs.readFileSync(filename)
    return src.equals(dist)

  @getPixel: (canvasElement, x, y) ->
    context = canvasElement.getContext('2d')
    pixel = context.getImageData(x,y,1,1)
    colorCode = "#"
    pixel.data.forEach((color) ->
      colorCode = colorCode + ("0" + color.toString(16)).slice(-2)
    )
    return colorCode

  @convertBuffer: (canvasElement) ->
    base64 = canvasElement.toDataURL().split(',')[1]
    return new Buffer(base64, 'base64')    
  
module.exports = CanvasUtility