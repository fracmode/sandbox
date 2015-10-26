
class D3Component
	selector: '#d3-window'
	$el: null

	numberOfLayers: 20
	numberOfSamples: 200
	layers0: null
	layers1: null

	windowWidth: 960
	windowHeight: 500

	stack: null

	color: null
	area: null

	svg: null

	durationTime: 1000

	constructor: ->
		@initEl()
		@init()
		@reloadData()
		@resetArea()

	initEl: ->
		@$el = $( @selector )
		@windowWidth = @$el.width()
		@windowHeight = @$el.height()

	init: ->
		@stack = window.d3.layout.stack().offset("wiggle")
		@layers0 = @createLayer()
		@layers1 = @createLayer()

		@color = window.d3.scale.linear()
			.range( ['#aad', '#556'] )

	resetArea: ->
		@$el.css {
			width: @windowWidth
			height: @windowHeight
		}

		graphX = window.d3.scale.linear()
			.domain( [0, @numberOfSamples - 1] )
			.range( [0, @windowWidth] )
		_getMaxY = =>
			window.d3.max( @layers0.concat( @layers1 ), (layer) ->
				return window.d3.max( layer, (d) ->
					return d.y0 + d.y
				)
			)
		graphY = window.d3.scale.linear()
			.domain( [0, _getMaxY() ] )
			.range( [@windowHeight, 0] )

		@area = window.d3.svg.area()
			.x( (d) => graphX( d.x ) )
			.y0( (d) => graphY( d.y0 ) )
			.y1( (d) => graphY( d.y0 + d.y ) )

		@initSVG()

	initSVG: ->
		if not @svg?
			@svg = window.d3.selectAll( @$el ).append('svg')

			@svg.selectAll('path')
				.data( @layers0 )
				.enter().append('path')
				.attr('d', @area)
				.style( 'fill', => @color( Math.random() ) )

		@svg.attr( 'width', @windowWidth )
			.attr( 'height', @windowHeight )

	reloadData: ->
		window.d3.selectAll('path').data( =>
			# d = @layers1
			# @layers1 = @layers0
			# @layers0 = d
			@layers1 = @layers0
			@layers0 = @createLayer()
		)

	transition: ->
		window.d3.selectAll('path')
			.transition()
			.duration( @durationTime )
			.attr( 'd', @area )

	createLayer: ->
		_bumpLayer = =>
			__bump = (array1) =>
				x = 1 / ( .1 + Math.random() )
				y = 2 * Math.random() - .5
				z = 10 / ( .1 + Math.random() )
				for i in [0...@numberOfSamples]
					w = (i / @numberOfSamples - y) * z
					array1[i] += x * Math.exp( -w * w )

			array = []
			for i in [0...@numberOfSamples]
				array[i] = 0
			for i in [0...5]
				__bump( array )
			return array.map( (d, i) -> { x: i, y: Math.max( 0, d ) } )

		@stack( window.d3.range( @numberOfLayers ).map( =>
			_bumpLayer()
		) )

	_getDefaultOrMax: ( val, defaultValue = 0, max = 0 ) ->
		val = defaultValue if not _.isNumber( val )
		Math.max( val, max )

	resetWindow: ->
		@windowWidth = @_getDefaultOrMax( parseInt( $('[name="graph-width"]').val() ), 640, 40 )
		@windowHeight = @_getDefaultOrMax( parseInt( $('[name="graph-height"]').val() ), 480, 30 )
		@resetArea()

	resetLayersAndSamples: ->
		numberOfLayers_prev = @numberOfLayers
		@numberOfLayers = @_getDefaultOrMax( parseInt( $('[name="number-of-layers"]').val() ), 20, 1 )
		@numberOfSamples = @_getDefaultOrMax( parseInt( $('[name="number-of-samples"]').val() ), 200, 1 )

		if @numberOfLayers isnt numberOfLayers_prev
			@$el.find('svg path').remove()
			@svg.remove()
			@svg = null



class App
	run: ->
		$(document).ready ->
			@d3Component = new D3Component()
			$('[js-update]').on 'click', =>
				@d3Component.resetLayersAndSamples()
				@d3Component.reloadData()
				@d3Component.resetWindow()
				@d3Component.transition()
		return

window.app = new App()
app.run()