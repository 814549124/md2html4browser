// Generated by CoffeeScript 1.10.0
var Marked;

Marked = null;

(function() {
  var m_instance;
  m_instance = null;
  return Marked = function() {
    var before_format, build, code_reg, em_reg, empty_reg, format, href_reg, img_reg, ol_reg, quote_reg, strong_reg, table_reg, title1_reg, title2_reg, title3_reg, title4_reg, title5_reg, title6_reg, ul_reg;
    if (m_instance) {
      return m_instance;
    }
    title1_reg = /^\s*#{1}(.*)/;
    title2_reg = /^\s*#{2}(.*)/;
    title3_reg = /^\s*#{3}(.*)/;
    title4_reg = /^\s*#{4}(.*)/;
    title5_reg = /^\s*#{5}(.*)/;
    title6_reg = /^\s*#{6}(.*)/;
    ul_reg = /^\s*[*,+,-]\s+(.*)/;
    ol_reg = /^\s*\d+\s+(.*)/;
    quote_reg = /^\s*>\s+(.*)/;
    empty_reg = /^\s*$/;
    code_reg = /^\s*```(.*)/;
    table_reg = /^\|/;
    em_reg = /\*([\w\u4e00-\u9fa5]+)\*/g;
    strong_reg = /\*\*([\w\u4e00-\u9fa5]+)\*\*/g;
    img_reg = /!\[(.*?)?\](?:\[(.*?)\])?\((.*?)\)/g;
    href_reg = /\[(.*?)?\](?:\[(.*?)\])?\((.*?)\)/g;
    before_format = function(content) {
      content = content.replace(strong_reg, '<strong>$1</strong>');
      content = content.replace(em_reg, '<em>$1</em>');
      content = content.replace(img_reg, '<img src="$3" id="$2" alt="$1">');
      return content = content.replace(href_reg, '<a href="$3" id="$2">$1</a>');
    };
    format = function(rows, objs, env) {
      var c, i, len, r, re, td, tds, zsobjs, zsr, zsrows, zstr;
      while (true) {
        r = rows.shift();
        if (r === '') {
          continue;
        } else {
          rows.unshift(r);
          break;
        }
      }
      if (!objs) {
        objs = [];
      }
      switch (env) {
        case 'ul':
          zsobjs = [];
          while (true) {
            r = rows.shift();
            if (r === void 0) {
              break;
            }
            switch (true) {
              case ul_reg.test(r):
                re = ul_reg.exec(r);
                zsobjs.push({
                  type: 'li',
                  content: re[1]
                });
                break;
              default:
                zsobjs = format([r], zsobjs);
            }
          }
          objs.push({
            type: 'ul',
            content: zsobjs
          });
          break;
        case 'ol':
          zsobjs = [];
          while (true) {
            r = rows.shift();
            if (r === void 0) {
              break;
            }
            switch (true) {
              case ol_reg.test(r):
                re = ol_reg.exec(r);
                zsobjs.push({
                  type: 'li',
                  content: re[1]
                });
                break;
              default:
                zsobjs = format([r], zsobjs);
            }
          }
          objs.push({
            type: 'ol',
            content: zsobjs
          });
          break;
        case 'quote':
          c = "";
          while (true) {
            r = rows.shift();
            if (r === void 0) {
              break;
            }
            re = quote_reg.exec(r);
            if (re) {
              c += ' ' + re[1];
            } else {
              c += ' ' + r;
            }
          }
          objs.push({
            type: 'quote',
            content: c
          });
          break;
        default:
          while (true) {
            r = rows.shift();
            if (r === void 0) {
              break;
            }
            switch (true) {
              case title6_reg.test(r):
                re = title6_reg.exec(r);
                objs.push({
                  type: 'h6',
                  content: re[1]
                });
                break;
              case title5_reg.test(r):
                re = title5_reg.exec(r);
                objs.push({
                  type: 'h5',
                  content: re[1]
                });
                break;
              case title4_reg.test(r):
                re = title4_reg.exec(r);
                objs.push({
                  type: 'h4',
                  content: re[1]
                });
                break;
              case title3_reg.test(r):
                re = title3_reg.exec(r);
                objs.push({
                  type: 'h3',
                  content: re[1]
                });
                break;
              case title2_reg.test(r):
                re = title2_reg.exec(r);
                objs.push({
                  type: 'h2',
                  content: re[1]
                });
                break;
              case title1_reg.test(r):
                re = title1_reg.exec(r);
                objs.push({
                  type: 'h1',
                  content: re[1]
                });
                break;
              case empty_reg.test(r):
                break;
              case ul_reg.test(r):
                zsrows = [];
                zsrows.push(r);
                while (true) {
                  zsr = rows.shift();
                  if (zsr === void 0 || empty_reg.test(zsr)) {
                    break;
                  }
                  zsrows.push(zsr);
                }
                objs = format(zsrows, objs, 'ul');
                break;
              case ol_reg.test(r):
                zsrows = [];
                zsrows.push(r);
                while (true) {
                  zsr = rows.shift();
                  if (zsr === void 0 || empty_reg.test(zsr)) {
                    break;
                  }
                  zsrows.push(zsr);
                }
                objs = format(zsrows, objs, 'ol');
                break;
              case quote_reg.test(r):
                zsrows = [];
                zsrows.push(r);
                while (true) {
                  zsr = rows.shift();
                  if (zsr === void 0 || empty_reg.test(zsr)) {
                    break;
                  }
                  zsrows.push(zsr);
                }
                objs = format(zsrows, objs, 'quote');
                break;
              case code_reg.test(r):
                re = code_reg.exec(r);
                c = '';
                while (true) {
                  zsr = rows.shift();
                  if (zsr === void 0 || code_reg.test(zsr)) {
                    break;
                  }
                  c += "\n" + zsr;
                }
                objs.push({
                  type: 'code',
                  lang: re[1],
                  content: c
                });
                break;
              case table_reg.test(r):
                c = [];
                objs.push({
                  type: 'table',
                  content: c
                });
                while (true) {
                  if (r === void 0 || !table_reg.test(r)) {
                    rows.unshift(r);
                    break;
                  }
                  tds = r.split('|');
                  tds.shift();
                  tds.pop();
                  zstr = [];
                  c.push(zstr);
                  for (i = 0, len = tds.length; i < len; i++) {
                    td = tds[i];
                    zstr.push(td);
                  }
                  r = rows.shift();
                }
                break;
              default:
                objs.push({
                  type: 'p',
                  content: r
                });
            }
          }
      }
      return objs;
    };
    build = function(objs) {
      var html, i, j, k, len, len1, len2, o, ref, td, tds_html, tr, trs_html;
      html = '';
      for (i = 0, len = objs.length; i < len; i++) {
        o = objs[i];
        switch (o.type) {
          case 'h1':
            html += "<h1>" + o.content + "</h1>";
            break;
          case 'h2':
            html += "<h2>" + o.content + "</h2>";
            break;
          case 'h3':
            html += "<h3>" + o.content + "</h3>";
            break;
          case 'h4':
            html += "<h4>" + o.content + "</h4>";
            break;
          case 'h5':
            html += "<h5>" + o.content + "</h5>";
            break;
          case 'h6':
            html += "<h6>" + o.content + "</h6>";
            break;
          case 'p':
            html += "<pre><p>" + o.content + "</p></pre>";
            break;
          case 'ul':
            html += "<ul>" + (build(o.content)) + "</ul>";
            break;
          case 'ol':
            html += "<ol>" + (build(o.content)) + "</ol>";
            break;
          case 'li':
            html += "<li>" + o.content + "</li>";
            break;
          case 'quote':
            html += "<blockquote>" + o.content + "</blockquote>";
            break;
          case 'code':
            html += "<pre><code class='lang-" + o.lang + "'>" + o.content + "</code></pre>";
            break;
          case 'table':
            trs_html = '';
            ref = o.content;
            for (j = 0, len1 = ref.length; j < len1; j++) {
              tr = ref[j];
              tds_html = '';
              for (k = 0, len2 = tr.length; k < len2; k++) {
                td = tr[k];
                tds_html += "<td>" + td + "</td>";
              }
              trs_html += "<tr>" + tds_html + "</tr>";
            }
            html += "<table>" + trs_html + "</table>";
        }
      }
      return html;
    };
    return m_instance = function(content) {
      var objs, rows;
      content = before_format(content);
      rows = content.split(/\r?\n/);
      objs = format(rows);
      return build(objs);
    };
  };
})();
