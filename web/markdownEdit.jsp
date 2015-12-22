<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
//	if(session.getAttribute("name")==null || session.getAttribute("uid")==null){
//		response.sendRedirect("/api_manage/login.jsp");
//	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>apiTools</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<!--link rel="stylesheet/less" href="common/less/bootstrap.less" type="text/css"/-->
<!--link rel="stylesheet/less" href="common/less/responsive.less" type="text/css"/-->
<!--script src="common/js/less-1.3.3.min.js"></script-->
<!--append ‘#!watch’ to the browser URL, then refresh the page. -->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">
<link href="common/google-code-prettify/prettify.css" type="text/css" rel="stylesheet" />
<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">
<link href="common/css/bootstrap-markdown.min.css" rel="stylesheet">
<link href="common/css/bootstrap-markdown.min.css" rel="stylesheet">
<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script src="common/js/jsonFormater.js" type="text/javascript"></script>
<script type="text/javascript" src="common/google-code-prettify/prettify.js"></script>
<script src="common/js/markdown.js"></script>
<script src="common/js/epiceditor.min.js"></script>
<script src="common/js/bootstrap-markdown.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    // do stuff when DOM is ready
    var basePath = '<%=basePath%>';
    $("pre").addClass("prettyprint");
	prettyPrint();
	$("#menuActive").find("li").each(function() {
		$(this).removeClass("active");
	});
	$("#menuActive li:nth-child(4)").addClass("active");
		
	var Request = new Object();
	Request = GetRequest();
	var apiID = Request["apiID"];
	if(typeof(apiID)!="undefined")
		
		$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=apiInfo&apiID="+apiID,null,function(data) {
			
			for(var i=0;i<eval(data.apiInfo).length;i++){
				var apiInfo = data.apiInfo[i];
				
				var cnName = apiInfo.cnName;
				var urlPath = apiInfo.urlPath;
				var isLogin = apiInfo.isLogin;
				var httpMethod = apiInfo.httpMethod;
				var author = apiInfo.author;
				var editInfo = apiInfo.editInfo;
				var paramIn = apiInfo.paramIn.paramIn;
				var paramOut = apiInfo.paramOut.paramOut;
				var tableInfo = apiInfo.tableInfo.tableInfo;						
				var resultInfo = format(JSON.stringify(apiInfo.resultInfo));
				var tableparamIn = 
				"#### 输入参数" +"\n" +
				"| 参数名称 | 参数描述 | 类型 | 示例 | 是否必须 |" +"\n" +
				"| ------------ | ------ | ------ | ------------ | ------ |" +"\n";
				var tableparamOut = 
				"#### 返回字段说明" +"\n" +
				"| 字段 | 解释说明 |" +"\n" +
				"| ------ | ------------ |" +"\n";
				var tabletableInfo = 
				"#### 使用到得数据表说明" +"\n" +
				"| 数据库名 | 表名 | 地址 |" +"\n" +
				"| ------ | --------- | -------------- |" +"\n";
				
				for(var k=0;k<eval(paramIn).length;k++){
					if(paramIn[k].paramName==""){
						tableparamIn="";
					}
					else{
						tableparamIn = tableparamIn +
						"| "+
						paramIn[k].paramName+" | "+
						paramIn[k].paramDescription+" | "+
						paramIn[k].paramType.split("*")[0]+" | "+
						paramIn[k].paramDefault+" | "+
						paramIn[k].isNeeded+" |"+"\n"
						;
					}			
					}
				for(var k=0;k<eval(paramOut).length;k++){
					if(paramOut[k].paramName==""){
						tableparamOut = "";
					}
					else{
						tableparamOut = tableparamOut +
						"| "+
						paramOut[k].paramName+" | "+
						paramOut[k].paramDescription+" |"+"\n"
						;
					}				
				}
				for(var k=0;k<eval(tableInfo).length;k++){
					if(tableInfo[k].datebaseName==""){
						tabletableInfo="";
					}
					else{
						tabletableInfo = tabletableInfo +
						"| "+
						tableInfo[k].datebaseName+" | "+
						tableInfo[k].tableName+" | "+
						tableInfo[k].ipAddress+" |"+"\n"
						;
					}				
				}
				
				var edit_areaText = "";
				
				edit_areaText = 
				"###"+cnName+"\n" +"\n" +

				"####详细描述" +"\n" +
				 editInfo +"\n" +"\n" +

				"#### 接口基本信息" +"\n" +
				"| 说明 | 描述 |" +"\n" +
				"| ------ | ------ |" +"\n" +
				"| 接口名 | " + cnName +"|" +"\n" +
				"| 作者 | " +author +"|" +"\n" +
				"| 访问 URL | " + urlPath +"|" +"\n" +
				"| 是否登录 | "+ isLogin +"|" +"\n" +
				"| 请求方式 | "+httpMethod+" |" +"\n" +"\n" +
				
				tableparamIn   +
				
				tableparamOut   +
				
				tabletableInfo  +

				"#### 返回结果示例" +"\n" +
				"```json" +"\n" +
				resultInfo +"\n" +
				"```";
				

				$("#edit_area").val(edit_areaText);
				var opts = {
						container: 'markdownEdit',
						textarea: 'edit_area',
						basePath: 'common',
						clientSideStorage: true,
						localStorageName: 'epiceditor',
						useNativeFullscreen: true,
						parser: marked,
						file: {
							name: 'epiceditor',
							defaultContent: '',
							autoSave: 100
						},
						theme: {
							base: '/themes/base/epiceditor.css',
							preview: '/themes/preview/preview-dark.css',
							editor: '/themes/editor/epic-dark.css'
						},
						button: {
							preview: true,
							fullscreen: true,
							bar: true
						},
						focusOnLoad: false,
						shortcut: {
							modifier: 18,
							fullscreen: 70,
							preview: 80
						},
						string: {
							togglePreview: 'Toggle Preview Mode',
							toggleEdit: 'Toggle Edit Mode',
							toggleFullscreen: 'Enter Fullscreen'
						},
						autogrow: false
					};
					var editor = new EpicEditor(opts);
					editor.load();
			}
			
			
		});
	else{
		var edit_areaText = 
			"### API名称" +"\n" +"\n" +

			"####详细描述" +"\n" +
			"escriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfode" +"\n" +
			"descriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfod" +"\n" +
			"descriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfod" +"\n" +
			"descriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfod" +"\n" +
			"descriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfod" +"\n" +
			"descriptionOFinfodescriptionOFinfodescriptionOFinfodescriptionOFinfod" +"\n" +"\n" +

			"#### 接口基本信息" +"\n" +
			"| 说明 | 描述 |" +"\n" +
			"| ------ | ------ |" +"\n" +
			"| 接口名 | cnName |" +"\n" +
			"| 作者 | author |" +"\n" +
			"| 访问 URL | /path1/path2 |" +"\n" +
			"| 是否登录 | 否 |" +"\n" +
			"| 请求方式 | get |" +"\n" +"\n" +

			"#### 输入参数" +"\n" +
			"| 参数名称 | 参数描述 | 类型 | 示例 | 是否必须 |" +"\n" +
			"| ------------ | ------ | ------ | ------------ | ------ |" +"\n" +
			"| param1 | description1 | type1 | example1 | 是 |" +"\n" +
			"| param2 | description2 | type2 | example2 | 是 |"  +"\n" +"\n" +

			"#### 返回字段说明" +"\n" +
			"| 字段 | 解释说明 |" +"\n" +
			"| ------ | ------------ |" +"\n" +
			"| return1 | description1 |" +"\n" +
			"| return2 | description2 |" +"\n" +"\n" +

			"#### 使用到得数据表说明" +"\n" +
			"| 数据库名 | 表名 | 地址 |" +"\n" +
			"| ------ | --------- | -------------- |" +"\n" +
			"| databaseName1 | table1 | 127.0.0.1 |" +"\n" +
			"| databaseName2 | table2 | 127.0.0.1 |" +"\n" +"\n" +

			"#### 返回结果示例" +"\n" +
			"```json" +"\n" +
			"{" +"\n" +
			"    \"result\": {" +"\n" +
			"       \"action_result\": true" +"\n" +
			"    }," +"\n" +
			"    \"errorCode\": \"0\"," +"\n" +
			"    \"errorMessage\": \"\"," +"\n" +
			"    \"status\": \"OK\"" +"\n" +
			"}" +"\n" +
			"```";
		$("#edit_area").val(edit_areaText);
		var opts = {
				container: 'markdownEdit',
				textarea: 'edit_area',
				basePath: 'common',
				clientSideStorage: true,
				localStorageName: 'epiceditor',
				useNativeFullscreen: true,
				parser: marked,
				file: {
					name: 'epiceditor',
					defaultContent: '',
					autoSave: 100
				},
				theme: {
					base: '/themes/base/epiceditor.css',
					preview: '/themes/preview/preview-dark.css',
					editor: '/themes/editor/epic-dark.css'
				},
				button: {
					preview: true,
					fullscreen: true,
					bar: true
				},
				focusOnLoad: false,
				shortcut: {
					modifier: 18,
					fullscreen: 70,
					preview: 80
				},
				string: {
					togglePreview: 'Toggle Preview Mode',
					toggleEdit: 'Toggle Edit Mode',
					toggleFullscreen: 'Enter Fullscreen'
				},
				autogrow: false
			};
			var editor = new EpicEditor(opts);
			editor.load();
	}
	
	
});

function GetRequest(){
		var url = location.search; //获取url中"?"符后的字串
				var theRequest = new Object();
		if (url.indexOf("?") != -1) {
			var str = url.substr(1);
			strs = str.split("&");
			for(var i = 0; i < strs.length; i ++) {
				theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
				}
			}
		return theRequest;
		}
		
function UrlDecode(zipStr){ 
	var uzipStr=""; 
	for(var i=0;i<zipStr.length;i++){ 
	var chr = zipStr.charAt(i); 
	if(chr == "+"){ 
	uzipStr+=" "; 
	}else if(chr=="%"){ 
	var asc = zipStr.substring(i+1,i+3); 
	if(parseInt("0x"+asc)>0x7f){ 
	uzipStr+=decodeURI("%"+asc.toString()+zipStr.substring(i+3,i+9).toString()); 
	i+=8; 
	}else{ 
	uzipStr+=AsciiToString(parseInt("0x"+asc)); 
	i+=2; 
	} 
	}else{ 
	uzipStr+= chr; 
	} 
	}
	return uzipStr; 
	}
	function StringToAscii(str){ 
	return str.charCodeAt(0).toString(16); 
	} 
	function AsciiToString(asccode){ 
	return String.fromCharCode(asccode); 
	}
	
	function format(txt,compress/*是否为压缩模式*/){/* 格式化JSON源码(对象转换为JSON文本) */  
        var indentChar = '    ';   
        if(/^\s*$/.test(txt)){   
            alert('数据为空,无法格式化! ');   
            return;   
        }   
        try{var data=eval('('+txt+')');}   
        catch(e){   
            alert('数据源语法错误,格式化失败! 错误信息: '+e.description,'err');   
            return;   
        };   
        var draw=[],last=false,This=this,line=compress?'':'\n',nodeCount=0,maxDepth=0;   
           
        var notify=function(name,value,isLast,indent/*缩进*/,formObj){   
            nodeCount++;/*节点计数*/  
            for (var i=0,tab='';i<indent;i++ )tab+=indentChar;/* 缩进HTML */  
            tab=compress?'':tab;/*压缩模式忽略缩进*/  
            maxDepth=++indent;/*缩进递增并记录*/  
            if(value&&value.constructor==Array){/*处理数组*/  
                draw.push(tab+(formObj?('"'+name+'":'):'')+'['+line);/*缩进'[' 然后换行*/  
                for (var i=0;i<value.length;i++)   
                    notify(i,value[i],i==value.length-1,indent,false);   
                draw.push(tab+']'+(isLast?line:(','+line)));/*缩进']'换行,若非尾元素则添加逗号*/  
            }else   if(value&&typeof value=='object'){/*处理对象*/  
                    draw.push(tab+(formObj?('"'+name+'":'):'')+'{'+line);/*缩进'{' 然后换行*/  
                    var len=0,i=0;   
                    for(var key in value)len++;   
                    for(var key in value)notify(key,value[key],++i==len,indent,true);   
                    draw.push(tab+'}'+(isLast?line:(','+line)));/*缩进'}'换行,若非尾元素则添加逗号*/  
                }else{   
                        if(typeof value=='string')value='"'+value+'"';   
                        draw.push(tab+(formObj?('"'+name+'":'):'')+value+(isLast?'':',')+line);   
                };   
        };   
        var isLast=true,indent=0;   
        notify('',data,isLast,indent,false);   
        return draw.join('');   
    }   

</script>		
		
	</head>
	<body onload="prettyPrint()">	
		<div class="container">
		<%@include file="header.jsp"%>
		<h2></h2>
			<div class="row clearfix">
				<div class="col-md-12 column">

					<div class="panel panel-default">
						<div class="panel-heading">
							<table>
								<tr>
									<td><h3 class="panel-title">MarkDown文档预览</h3></td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<div class="col-md-12 column">
					<div class="row clearfix">
						<div class="col-md-6 column">
							<div id="markdownEdit" style="height:560px;overflow-y:auto; ">
								<textarea id="markdownEditarea">
								</textarea>
							</div>
							<textarea id="edit_area" style="display:none ">
							<%=request.getParameter("apiInfo")%>
							
							</textarea>
						</div>
						
						<div class="col-md-6 column">
							<div id="document" style="height:560px;overflow-y:auto; ">
								<h2>
									基本 Markdown 语法
								</h2>
								<h3>
									1. 标题
								</h3>
								<pre>
									<code>
一级标题
=============

二级标题
-------------
									</code>
								</pre>
								<pre>
									<code>
# 一级标题 
## 二级标题 
### 三级标题 
#### 四级标题 
##### 五级标题 
###### 六级标题
									</code>
								</pre>
								<h3>
									2. 列表
								</h3>
								<pre>
									<code>
+ 无序列表1 
+ 无序列表2
+ 无序列表3

- 无序列表1 
- 无序列表2 
- 无序列表3 

* 无序列表1
* 无序列表2
* 无序列表3
										
1. 有序列表1 
2. 有序列表2 
3. 有序列表3
									</code>
								</pre>
								<h3>
									3. 引用
								</h3>
								<pre>
									<code>
&gt; 这个是引用 
&gt; 是不是和电子邮件中的 
&gt; 引用格式很像
									</code>
								</pre>
								<h3>
									4. 粗体与斜体
								</h3>
								<pre>
									<code>
**这个是粗体** 
*这个是斜体*
									</code>
								</pre>
								<h3>
									5. 强调
								</h3>
								<pre>
									<code>
*single asterisks*
_single underscores_
**double asterisks**
__double underscores__
									</code>
								</pre>
								<h3>
									6. 图片与链接
								</h3>
								<p>
									<strong>
										插入图片
									</strong>
								</p>
								<pre>
									<code>
![image description](http://www.baidu.com "image title")
									</code>
								</pre>
								<p>
									<strong>
										插入链接
									</strong>
								</p>
								<pre>
									<code>
[link description](http://www.baidu.com/)
									</code>
								</pre>
								<p>
									<strong>
										图片链接
									</strong>
								</p>
								<pre>
									<code>
[![][jane-eyre-pic]][jane-eyre-douban] 
[jane-eyre-pic]: http://img3.douban.com/mpic/s1108264.jpg
[jane-eyre-douban]: http://book.douban.com/subject/1141406/

![image description](http://www.baidu.com/1.jpg "image title")
									</code>
								</pre>
								<h3>
									7. 代码
								</h3>
								<p>
									用TAB键起始的段落，会被认为是代码块
								</p>
								<pre>
									<code>
	&lt;php&gt; 
		echo “hello world"; 
	&lt;/php&gt;
									</code>
								</pre>
								<p>
									如果在一个行内需要引用代码，只要用反引号`引起来就好
								</p>
								<pre>
									<code>
Use the `printf()` function.
									</code>
								</pre>
								<h3>
									8. 分割线
								</h3>
								<p>
									可以在一行中用三个以上的星号、减号、底线来建立一个分隔线
								</p>
								<pre>
									<code>
* * *
***
*****
- - -
---------------------------------------
									</code>
								</pre>
								<h3>
									9. 反斜杠
								</h3>								
								<pre>
									<code>
\*literal asterisks\*
									
\   反斜线
`   反引号
*   星号
_   底线
{}  花括号
[]  方括号
()  括弧
#   井字号
+   加号
-   减号
.   英文句点
!   惊叹号
									</code>
								</pre>
								<h2>
									github扩展语法
								</h2>
								<h3>
									1. 删除线
								</h3>
								<pre>
									<code>
~~Mistaken text.~~
									</code>
								</pre>
								<h3>
									2. 代码块与语法高亮
								</h3>
								<pre>
									<code>
```ruby 
require 'redcarpet' 
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html 
```
									</code>
								</pre>
								<h3>
									3. 表格
								</h3>
								<pre>
									<code>
| Tables        | Are           | Cool  | 
| ------------- |:-------------:| -----:| 
| col 3 is      | right-aligned | $1600 | 
| col 2 is      | centered      | $12   | 
| zebra stripes | are neat      | $1    |
									</code>
								</pre>
								<h3>
									4. 任务列表
								</h3>
								<pre>
									<code>
- [x] @mentions, #refs, [links](), **formatting**, and &lt;del&gt;tags&lt;/del&gt;
- [x] list syntax is required (any unordered or ordered list supported) 
- [x] this is a complete item - [ ] this is an incomplete item
									</code>
								</pre>
								<h2>
									其他高级用法
								</h2>
								<h3>
									Cross-reference (named anchor) in markdown
								</h3>
								<pre>
									<code>
Take me to [pookie](#pookie) &lt;a name="pookie"&gt;&lt;/a&gt;
									</code>
								</pre>
								<h3>
									引用代码块中包含反引号
								</h3>
								<p>
									只需使用比代码块中反引号更多的连续反引号来实现
									<br>
									例如：引用 Markdown 代码区段：
								</p>
								<pre>
									<code>
```` 
print($abc, `abc`, ``ab``);  
````
``` 
print($abc, `abc`, ``ab``); 
```
									</code>
								</pre>
							</div>
						</div>
					</div>
				</div>
							
						</div>
					</div>
				</div>
				
			</div>
			<div class="row clearfix">
			<div class="col-md-12 column">
			<%@include file="footer.jsp"%>
			</div>
		</div>
		</div>
	</body>

</html>


