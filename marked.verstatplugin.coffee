marked = require 'marked'

module.exports = (next) ->

	@preprocessor "markedPrecompiler",
		srcExtname: '.md'
		priority: 100
		preprocess: (file, done) =>
			try
				if file.processor is 'marked'
					precompiledString = marked file.source
					file.fn = -> precompiledString
					@modified file
					done()
			catch err
				@log "ERROR", "error compiling marked", err
				done err

	@processor 'marked',
		srcExtname: '.md'
		extname: '.html'
		compile: (file, options = {}, done) =>
			try
				templateData = {}
				@emit 'templateData', file, templateData
				done null, file.fn templateData
			catch e
				done e

	next()