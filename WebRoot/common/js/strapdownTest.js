$(function(){
	$('#target-editor-twitter').markdown({
		hiddenButtons:'cmdPreview',	
		//newEle.type="text/javascript";
		//newEle.src="flowplayer/flowplayer-3.1.4.min";
		//footer:'<div id="twitter-footer" class="well" style="display:none;"></div><small id="twitter-counter" class="text-success">140 character left</small>',
		onChange:function(e){
			var content = e.parseContent(),
				content_length = (content.match(/\n/g)||[]).length + content.length

			if (content == '') {
				$('#twitter-footer').hide()
			} else {
				$('#twitter-footer').show().html(content)				
				//$('#strapdown').show().html(content)
				//document.getElementsByTagName("head").InnerHTML="<xmp>gggg</xmp>"
				//$("head").append("<link rel='stylesheet' type='text/css' href='flowplayer/style.css'>")
				//$("head").show().html("<xmp>"+content.substring(3,content.length-4)+"</xmp>")
				//jQuery.getScript("strapdown.js", function(data, status, jqxhr) {})
			}		
			$('#twitter-counter').removeClass('text-success').addClass('text-danger').html(content_length)
		}
	})
})