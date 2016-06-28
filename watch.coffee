watch = require 'watch'
exec = require('child_process').exec

watch.watchTree '.',(f,curr,prev)->
	if typeof f is 'object' && prev is null && curr is null
		console.log '开始监听'
	else if prev is null

	else if curr.nlink is 0

	else
		if f is 'md2html4browser.coffee'
			console.log "准备转换,#{new Date()}"
			exec 'coffee -b -c md2html4browser.coffee',(error,stdout,stderr)->
               console.log("error:#{error}")
               console.log("stdout:#{stdout}")
               console.log("stderr:#{stderr}")
	