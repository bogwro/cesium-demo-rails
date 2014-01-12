require [
  'jquery'
  'Cesium'
], ($, Cesium) ->

  '''
  This application is using Cesium's default Bing Maps key.
  Please create a new key for the application as soon as possible and prior to deployment by visiting https://www.bingmapsportal.com/, and provide your key to Cesium by setting the Cesium.BingMapsApi.defaultKey property before constructing the CesiumWidget or any other object that uses the Bing Maps API.
  '''
#  Cesium.BingMapsApi.defaultKey = YOUR_BING_MAPS_API_KEY

  # DEMO ONLY:
  Cesium.BingMapsApi.defaultKey = 'ArLFUyzkdmYo5tG6DMLh9SkTgl5nemnBepRo63ibpcdvJKDoEp1arFJRLVfmpCl4';


  $ ->

    canvas = $('#globe')[0]
    @scene = new Cesium.Scene canvas

    primitives = @scene.getPrimitives()

    bing = new Cesium.BingMapsImageryProvider(
      url: 'http://dev.virtualearth.net'
      mapStyle: Cesium.BingMapsStyle.AERIAL
      proxy: if Cesium.FeatureDetection.supportsCrossOriginImagery() then undefined else new Cesium.DefaultProxy('/proxy/')
    )

    terrainProvider = new Cesium.CesiumTerrainProvider(
      url: 'http://cesium.agi.com/smallterrain'
    )

    ellipsoid = Cesium.Ellipsoid.WGS84
    centralBody = new Cesium.CentralBody(ellipsoid)
    centralBody.getImageryLayers().addImageryProvider(bing)
    centralBody.terrainProvider = terrainProvider
    primitives.setCentralBody(centralBody)

    new Cesium.SceneTransitioner(@scene, ellipsoid)

    ##################################################################
    #   INSERT CODE HERE to create graphics primitives in the scene.
    ##################################################################

    animate = =>
      # INSERT CODE HERE to update primitives based on changes to animation time, camera parameters, etc.

    tick = =>
      @scene.initializeFrame()
      animate()
      @scene.render()
      Cesium.requestAnimationFrame(tick)

    tick()

    canvas.oncontextmenu = =>
      false

    onResize = =>
      width = canvas.clientWidth
      height = canvas.clientHeight
      return if canvas.width == width and canvas.height == height
      canvas.width = width
      canvas.height = height
      @scene.getCamera().frustum.aspectRatio = width / height


    $(window).on('resize', onResize)
    onResize()