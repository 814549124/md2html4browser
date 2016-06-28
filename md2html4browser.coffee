Marked = null
(()->
	m_instance = null

	Marked = ()->
		if m_instance
			return m_instance
		title1_reg = /^\s*#{1}(.*)/
		title2_reg = /^\s*#{2}(.*)/
		title3_reg = /^\s*#{3}(.*)/
		title4_reg = /^\s*#{4}(.*)/
		title5_reg = /^\s*#{5}(.*)/
		title6_reg = /^\s*#{6}(.*)/
		ul_reg = /^\s*[*,+,-]\s+(.*)/
		ol_reg = /^\s*\d+\s+(.*)/
		quote_reg = /^\s*>\s+(.*)/
		empty_reg = /^\s*$/
		code_reg = /^\s*```(.*)/
		table_reg = /^\|/
		em_reg = /\*([\w\u4e00-\u9fa5]+)\*/g
		strong_reg = /\*\*([\w\u4e00-\u9fa5]+)\*\*/g
		img_reg = /!\[(.*?)?\](?:\[(.*?)\])?\((.*?)\)/g
		href_reg = /\[(.*?)?\](?:\[(.*?)\])?\((.*?)\)/g
		before_format = (content)->
			content = content.replace strong_reg,'<strong>$1</strong>'
			content = content.replace em_reg,'<em>$1</em>'
			content = content.replace img_reg,'<img src="$3" id="$2" alt="$1">'
			content = content.replace href_reg,'<a href="$3" id="$2">$1</a>'

		format = (rows,objs,env)->
			#去掉头部的空行
			while true
				r = rows.shift()
				if r is undefined || r is ''
					continue
				else
					rows.unshift(r)
					break
			if not objs
				objs = []

			switch env
				when 'ul'
					zsobjs = []
					
					while true
						r = rows.shift()
						if r is undefined
							break
						switch true
							when ul_reg.test r
								re = ul_reg.exec r
								zsobjs.push {
									type:'li'
									content:re[1]
								}
							else
								zsobjs = format([r],zsobjs)
					objs.push {
						type:'ul'
						content:zsobjs
					}
				when 'ol'
					zsobjs = []
					
					while true
						r = rows.shift()
						if r is undefined
							break
						switch true
							when ol_reg.test r
								re = ol_reg.exec r
								zsobjs.push {
									type:'li'
									content:re[1]
								}
							else
								zsobjs = format([r],zsobjs)
					objs.push {
						type:'ol'
						content:zsobjs
					}
				when 'quote'
					c = ""
					while true
						r = rows.shift()
						if r is undefined
							break
						re = quote_reg.exec r
						if re
							c += ' ' + re[1]
						else
							c += ' ' + r
					objs.push {
						type:'quote'
						content:c
					}
				else
					while true
						r = rows.shift()
						if r is undefined
							break
						switch true
							when title6_reg.test r
								re = title6_reg.exec r
								objs.push {
									type: 'h6'
									content: re[1]
								}
							when title5_reg.test r
								re = title5_reg.exec r
								objs.push {
									type: 'h5'
									content: re[1]
								}
							when title4_reg.test r
								re = title4_reg.exec r
								objs.push {
									type: 'h4'
									content: re[1]
								}
							when title3_reg.test r
								re = title3_reg.exec r
								objs.push {
									type: 'h3'
									content: re[1]
								}
							when title2_reg.test r
								re = title2_reg.exec r
								objs.push {
									type: 'h2'
									content: re[1]
								}
							when title1_reg.test r
								re = title1_reg.exec r
								objs.push {
									type: 'h1'
									content: re[1]
								}
							when empty_reg.test r
								break
							when ul_reg.test r
								zsrows = []
								zsrows.push r
								while true
									zsr = rows.shift()
									if zsr is undefined || empty_reg.test zsr
										break
									zsrows.push zsr
								objs = format(zsrows,objs,'ul')
							when ol_reg.test r
								zsrows = []
								zsrows.push r
								while true
									zsr = rows.shift()
									if zsr is undefined || empty_reg.test zsr
										break
									zsrows.push zsr
								objs = format(zsrows,objs,'ol')
							when quote_reg.test r
								zsrows = []
								zsrows.push r
								while true
									zsr = rows.shift()
									if zsr is undefined || empty_reg.test zsr
										break
									zsrows.push zsr
								objs = format(zsrows,objs,'quote')
							when code_reg.test r
								re = code_reg.exec r
								c = ''
								while true
									zsr = rows.shift()
									if zsr is undefined || code_reg.test zsr
										break
									c += zsr
								objs.push {
									type:'code'
									lang: re[1]
									content:c
								}
							when table_reg.test r
								c = []
								objs.push {
									type:'table'
									content:c
								}
								while true
									if r is undefined || not table_reg.test r
										rows.unshift r
										break
									tds = r.split('|')
									tds.shift()
									tds.pop()
									zstr = []
									c.push zstr
									for td in tds
										zstr.push td
									r = rows.shift()
							else
								objs.push {
									type:'p'
									content:r
								}

							

			objs
		build = (objs)->
			html = ''
			for o in objs
				switch o.type
					when 'h1'
						html += "<h1>#{o.content}</h1>"
					when 'h2'
						html += "<h2>#{o.content}</h2>"
					when 'h3'
						html += "<h3>#{o.content}</h3>"
					when 'h4'
						html += "<h4>#{o.content}</h4>"
					when 'h5'
						html += "<h5>#{o.content}</h5>"
					when 'h6'
						html += "<h6>#{o.content}</h6>"
					when 'p'
						html += "<pre><p>#{o.content}</p></pre>"
					when 'ul'
						html += "<ul>#{build(o.content)}</ul>"
					when 'ol'
						html += "<ol>#{build(o.content)}</ol>"
					when 'li'
						html += "<li>#{o.content}</li>"
					when 'quote'
						html += "<blockquote>#{o.content}</blockquote>"
					when 'code'
						html += "<pre><code class='lang-#{o.lang}'>#{o.content}</code></pre>"
					when 'table'
						trs_html = ''
						for tr in o.content
							tds_html = ''
							for td in tr
								tds_html += "<td>#{td}</td>"
							trs_html += "<tr>#{tds_html}</tr>"
						html += "<table>#{trs_html}</table>"
			
			html

		m_instance = (content)->
			content = before_format content
			rows = content.split(/\r?\n/)
			objs = format(rows)
			build(objs)

)()
