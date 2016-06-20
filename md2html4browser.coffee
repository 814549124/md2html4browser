Marked = null
(()->
	m_instance = null

	Marked = ()->
		if m_instance
			return m_instance
		title1_reg = /^#\s+(.*)/g
		title2_reg = /^#{2}\s+(.*)/g
		title3_reg = /^#{3}\s+(.*)/g
		title4_reg = /^#{4}\s+(.*)/g
		title5_reg = /^#{5}\s+(.*)/g
		title6_reg = /^#{6}\s+(.*)/g
		ul_list_reg	= /^[\*,+,-]\s+(.*)/g
		ol_list_reg	= /^\d+\s+(.*)/g
			
		m_instance = (content)->
			total_html = ''
			block_reg = /(?:\r?\n){2,}/mg
			row_reg = /\r?\n/g
			title1_reg = /^#\s+(.*)/g
			title2_reg = /^#{2}\s+(.*)/g
			title3_reg = /^#{3}\s+(.*)/g
			title4_reg = /^#{4}\s+(.*)/g
			title5_reg = /^#{5}\s+(.*)/g
			title6_reg = /^#{6}\s+(.*)/g
			ul_list_reg	= /^[\*,+,-]\s+(.*)/g	
			ol_list_reg	= /^\d+\s+(.*)/g
			paragraph_reg = /^\w|^[\u4e00-\u9fa5]/g

			# 提前对代码段进行格式化
			code_reg = /```(\w*)\s*\r?\n([\s\S]*?)```/mg
			code_seg = []
			i = 0
			while null isnt (re = code_reg.exec(content))
				code_seg.push "<pre><code class='lang-#{re[1]}'>\r\n#{re[2]}\r\n</code></pre>"
				content = content.replace re[0],"\x00\x01\x02#{i}"
				i++

			blocks = content.split block_reg
			for block in blocks
				objs = []
				html = ''

				# 对小字体进行转换
				block = block.replace(/\*{2}(.+?)\*{2}/g,'<strong>$1</strong>')
				block = block.replace(/\*(.+?)\*/g,'<em>$1</em>')
				# 转换链接
				block = block.replace(/!\[(.+?)\](\[(.*?)\])?(\((.+?)\))?/g,'<img src="$5" id="$3" alt="$1">')
				block = block.replace(/\[(.+?)\](\[(.*?)\])?\((.+?)\)/g,'<a href="$4" id="$3">$1</a>')
				block = block.replace(/\[(.+?)\]\[(.*?)\]/g,'<a href="#$2">$1</a>')

				row_reg.lastIndex = 0
				rows = block.split row_reg
				row_len = rows.length
				row1 = rows[0]

				paragraph_reg.lastIndex = 0
				switch true
					when paragraph_reg.test(row1)
						# BUG 再进行判断,看看是有序列表么
						if not /^\d+\s+/.test(row1)
							block = block.replace(/\r?\n$/g,'')
							block = block.replace(/\r?\n/g,'<br>')
							row_reg.lastIndex = 0
							rows = block.split row_reg

				for r in rows
					title1_reg.lastIndex = 0
					title2_reg.lastIndex = 0
					title3_reg.lastIndex = 0
					title4_reg.lastIndex = 0
					title5_reg.lastIndex = 0
					title6_reg.lastIndex = 0
					ul_list_reg.lastIndex = 0
					ol_list_reg.lastIndex = 0
					if r is ''
						continue
					switch true
						when title1_reg.test r
							title1_reg.lastIndex = 0
							re = title1_reg.exec r
							objs.push {
								type: 'h1'
								content: re[1]
							}
						when title2_reg.test r
							title2_reg.lastIndex = 0
							re = title2_reg.exec r
							objs.push {
								type: 'h2'
								content: re[1]
							}
						when title3_reg.test r
							title3_reg.lastIndex = 0
							re = title3_reg.exec r
							objs.push {
								type: 'h3'
								content: re[1]
							}
						when title4_reg.test r
							title4_reg.lastIndex = 0
							re = title4_reg.exec r
							objs.push {
								type: 'h4'
								content: re[1]
							}
						when title5_reg.test r
							title5_reg.lastIndex = 0
							re = title5_reg.exec r
							objs.push {
								type: 'h5'
								content: re[1]
							}
						when title6_reg.test r
							title6_reg.lastIndex = 0
							re = title6_reg.exec r
							objs.push {
								type: 'h6'
								content: re[1]
							}
						when ul_list_reg.test r
							ul_list_reg.lastIndex = 0
							re = ul_list_reg.exec r
							objs.push {
								type: 'li'
								content: re[1]
							}
						when ol_list_reg.test r
							ol_list_reg.lastIndex = 0
							re = ol_list_reg.exec r
							objs.push {
								type: 'li'
								content: re[1]
							}
						else
							objs.push {
								type: 'p'
								content: r
							}

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
						when 'li'
							html += "<li>#{o.content}</li>"
						when 'p'
							html += "<p>#{o.content}</p>"
						else
							html += o.content

				
				ul_list_reg.lastIndex = 0
				ol_list_reg.lastIndex = 0
				switch true
					when ul_list_reg.test(row1)
						html = "<ul>#{html}</ul>"

					when ol_list_reg.test(row1)
						html = "<ol>#{html}</ol>"

				total_html += html

			# 转换代码
			for k, v of code_seg
				total_html = total_html.replace "\x00\x01\x02#{k}",v
			return total_html


)()
