fs = require('fs')

class CanvasUtility
  @save: (canvasData, filename) ->
    fs.writeFileSync(filename, CanvasUtility.convertBuffer(canvasData))

  @compare: (canvasData, filename) ->
    src = CanvasUtility.convertBuffer(canvasData)
    dist = fs.readFileSync(filename)
    return src.equals(dist)
    
  @convertBuffer: (canvasData) ->
    base64 = canvasData.toDataURL().split(',')[1]
    return new Buffer(base64, 'base64')    
    
module.exports = CanvasUtility