/*
 * markdown-editor.js
 *
 * Markdown Editor plugin for jQuery.
 */

function markdown2html(text) {
    return markdown.toHTML(text);
}

! function ($) {
    var Markdown = function (element, options, commands) {
        this.options = options;
        this.$textarea = $(element); //将次textarea 封装为JQuery对象赋给MarkDown的$textarea元素
        if (!this.$textarea.is('textarea')) { //is 可以检测元素 http://www.w3school.com.cn/jquery/traversing_is.asp
            alert('only textarea can change to markdown!');
            return;
        }
        this.buildMarkdown(commands);
    };

    var TextAreaDelegate = function (the_toolbar, the_textarea, the_preview, options) {
        this.$toolbar = the_toolbar;
        this.$textarea = the_textarea;
        this.$container = the_textarea.parent();
        this.$dom = the_textarea.get(0);
        this.$preview = the_preview;
        this.$options = options;
    };

    TextAreaDelegate.prototype = {

        constructor: TextAreaDelegate,

        enableAllButtons: function (enabled) {
            var btns = this.$toolbar.find('button[data-cmd]');
            if (enabled) {
                btns.removeAttr('disabled');
            } else {
                btns.attr('disabled', 'disabled');
            }
        },

        enableButton: function (key, enabled) {
            var btn = this.$toolbar.find('button[data-cmd="' + key + '"]');
            if (enabled) {
                btn.removeAttr('disabled');
            } else {
                btn.attr('disabled', 'disabled');
            }
        },

        getText: function () {
            return this.$textarea.val();
        },

        getOption: function (key) {
            return this.$options[key];
        },

        paste: function (s) {
            this.$dom.setRangeText(s);
        },

        //获取指定内容 
        getSelection: function () {
            return this.$dom.value.substring(this.$dom.selectionStart, this.$dom.selectionEnd);
        },

        //获取光标所在行
        selectCurrentLine: function () {
            var pos = this.getCaretPosition();
            var ss = this.$dom.value.split('\n'); //分割 返回一个数组 http://www.w3school.com.cn/js/jsref_split.asp
            var start = 0;
            var end = 0;
            for (var i = 0; i < ss.length; i++) {
                var s = ss[i];
                //光标位置小于下一行第一个
                if ((start + s.length + 1) > pos) {
                    end = start + s.length;
                    break;
                }
                start += (s.length + 1); //如果光标不在本行，将开始点置为下一行起始
            }
            //start为本行第一个,end为本行最后一个(\n)
            this.setSelection(start, end); //选中光标所在的一行
            return this.getSelection();
        },

        //获取选中内容的开始位置
        getCaretPosition: function () {
            //输入性元素selection起点的位置,可读写
            return this.$dom.selectionStart;
        },

        unselect: function () {
            var p = this.getCaretPosition();
            this.$dom.setSelectionRange(p, p);
        },

        setSelection: function (start, end) {
            this.$dom.setSelectionRange(start, end);
        },
        //设置选中区域 开始==结束
        setCaretPosition: function (pos) {
            this.$dom.setSelectionRange(pos, pos);
        },
    };

    Markdown.prototype = {
        constructor: Markdown,

        applyCss: function () {
            var css = {
                'resize': 'none',
                'font-family': 'Monaco, Menlo, Consolas, "Courier New", monospace',
            };
            $that = this;
            $.map(css, function (v, k) { //遍历/each http://www.w3school.com.cn/jquery/traversing_map.asp
                $that.$textarea.css(k, v);
            });
        },

        executeCommand: function (cmd) {
            var fn = this.$commands[cmd];
            fn && fn(this.$delegate);
        },

        buildMarkdown: function (commands) {
            $that = this;
            var L = ['<div class="btn-toolbar markdown-toolbar" style="font-size: 0; margin-bottom: 10px; margin-top: 10px;"><div class="btn-group btn-group-sm">'];
            $.each(this.options.buttons, function (index, ele) {
                if (ele == '|') { //遍历button 以 | 分组
                    L.push('</div><div class="btn-group btn-group-sm">');
                } else {
                    $icon = $that.options.icons[ele] || 'glyphicon glyphicon-star'; //button的icon 默认为☆
                    $tooltip = $that.options.tooltips[ele] || ''; //button的title 默认为☆
                    //字体 下拉 单独处理
                    if (ele == 'heading') {
                        L.push('<button class="btn btn-default dropdown-toggle" data-toggle="dropdown" data-cmd="heading" title="' + $tooltip + '"><span class="' + $icon + '"></span> <span class="caret"></span></button>');
                        L.push('<ul class="dropdown-menu" role="menu">');
                        //data-cmd 指定绑定的函数名
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading1"># Heading 1</a></li>');
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading2">## Heading 2</a></li>');
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading3">### Heading 3</a></li>');
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading4">#### Heading 4</a></li>');
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading5">##### Heading 5</a></li>');
                        L.push('<li><a href="javascript:void(0)" data-type="md" data-cmd="heading6">###### Heading 6</a></li>');
                        L.push('</ul>');
                    } else {
                        //普通按钮
                        L.push('<button type="button" data-type="md" data-cmd="' + ele + '" title="' + $tooltip + '" class="btn btn-default' + ($icon.indexOf('glyphicon-white') >= 0 ? ' btn-info' : '') + '"><span class="' + $icon + '"></span></button>');
                    }
                }
            });
            var tw = this.$textarea.outerWidth() - 2; //返回元素的宽度（包括内边距和边框） http://www.w3school.com.cn/jquery/jquery_dimensions.asp
            var th = this.$textarea.outerHeight() - 2; //返回元素的高度（包括内边距和边框）减去边框宽度
            L.push('</div></div><div class="markdown-preview" style="display:none;padding:0;margin:0;width:' + tw + 'px;height:' + th + 'px;overflow:scroll;background-color:white;border:1px solid #ccc;border-radius:4px"></div>');
            this.$commands = commands; //各种按钮对应的处理函数
            //before() 方法在被选元素前插入指定的内容 http://www.w3school.com.cn/jquery/manipulation_before.asp
            this.$textarea.before(L.join('')); //join 将数组转化为字符串,各个元素以''连接 http://www.w3school.com.cn/js/jsref_join.asp
            this.$toolbar = this.$textarea.parent().find('div.markdown-toolbar');
            this.$preview = this.$textarea.parent().find('div.markdown-preview'); //隐藏 高度、宽度和输入框一致
            //构建编辑器 包含'工具栏'、'文本输入域'、'预览框'
            this.$delegate = new TextAreaDelegate(this.$toolbar, this.$textarea, this.$preview, this.options);
            this.$toolbar.find('*[data-type=md]').each(function () {
                $btn = $(this);
                //data-cmd 指定绑定的函数名
                var cmd = $btn.attr('data-cmd');
                //为每个按钮绑定click事件
                $btn.click(function () {
                    $that.executeCommand(cmd);
                });
                try {
                    //$btn.tooltip();
                } catch (e) { /* ignore if tooltip.js not exist */ }
            });
            this.applyCss();
        },

        showBackdrop: function () {
            if (!this.$backdrop) {
                this.$backdrop = $('<div class="modal-backdrop" />').appendTo(document.body);
            }
        },

        hideBackdrop: function () {
            this.$backdrop && this.$backdrop.remove();
            this.$backdrop = null;
        },
    };

    function setHeading(s, heading) {
        var re = new RegExp('^#{1,6}\\s');
        var h = re.exec(s);
        if (h != null) {
            s = s.substring(h[0].length);
        }
        return heading + s;
    }

    var commands = {

        heading1: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '# '));
        },

        heading2: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '## '));
        },

        heading3: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '### '));
        },

        heading4: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '#### '));
        },

        heading5: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '##### '));
        },

        heading6: function (delegate) {
            var line = delegate.selectCurrentLine();
            delegate.paste(setHeading(line, '###### '));
        },
        //粗体
        bold: function (delegate) {
            var s = delegate.getSelection();
            if (s == '') { //没有选中文本时
                delegate.paste('****');
                // make cursor to: **|**
                delegate.setCaretPosition(delegate.getCaretPosition() + 2);
            } else {
                delegate.paste('**' + s + '**');
            }
        },
        //斜体
        italic: function (delegate) {
            var s = delegate.getSelection();
            if (s == '') {
                delegate.paste('**');
                // make cursor to: *|*
                delegate.setCaretPosition(delegate.getCaretPosition() + 1);
            } else {
                delegate.paste('*' + s + '*');
            }
        },
        //超链接
        link: function (delegate) {
            var s = '<div class="modal fade" style="overflow-y:hidden;" data-backdrop="static" role="dialog" aria-hidden="true">' +
                    '   <div class="modal-dialog">' +
                    '       <div class="modal-content">' +
                    '           <div class="modal-header">' +
                    '               <button type="button" class="close" data-dismiss="modal">&times;</button>' +
                    '               <h3 class="modal-title">Hyper Link</h3>' +
                    '           </div>' +
                    '           <div class="modal-body">' +
                    '               <form class="form-horizontal" role="form">' +
                    '                   <div class="form-group">' +
                    '                       <label class="col-md-2 control-label">Text</label>' +
                    '                       <div class="col-md-10 controls">' +
                    '                           <input name="text" class="form-control input-md" type="text" value="" />' +
                    '                       </div>' +
                    '                   </div>' +
                    '                   <div class="form-group">' +
                    '                       <label class="col-md-2 control-label">Link</label>' +
                    '                       <div class="col-md-10 controls">' +
                    '                           <input name="link" class="form-control input-md" type="text" placeholder="http://" value="" />' +
                    '                       </div>' +
                    '                   </div>' +
                    '               </form>' +
                    '           </div>' +
                    '           <div class="modal-footer">' +
                    '               <a href="#" class="btn btn-md btn-primary">OK</a>' +
                    '               <a href="#" class="btn btn-md btn-default" data-dismiss="modal">Close</a>' +
                    '           </div>' +
                    '       </div>' +
                    '   </div>' +
                    '</div>';            
            $('body').prepend(s);
            var $modal = $('body').children(':first');
            var sel = delegate.getSelection();
            //有选中值，将此值赋为link的name
            if (sel != '') {
                $modal.find('input[name=text]').val(sel);
            }
            $modal.modal('show');
            $modal.find('.btn-primary').click(function () {
                var text = $.trim($modal.find('input[name=text]').val());
                var link = $.trim($modal.find('input[name=link]').val());
                if (link == '') link = 'http://';
                //没有加http://时,为其加上
                if (link.indexOf('http://') === -1) link = 'http://' + link;
                if (text == '') text = link;
                delegate.paste('[' + text + '](' + link + ')');
                $modal.modal('hide');
            });
            $modal.on('hidden.bs.modal', function () {
                $modal.remove();
            });
        },
        //邮件
        email: function (delegate) {
            var s = '<div class="modal fade" style="overflow-y:hidden;" data-backdrop="static" role="dialog" aria-hidden="true">' +
                    '	<div class="modal-dialog">' +
                    '		<div class="modal-content">' +
                    '			<div class="modal-header">' +
                    '				<button type="button" class="close" data-dismiss="modal">&times;</button>' +
                    '				<h3 class="modal-title">Email Address</h3>' +
                    '			</div>' +
                    '			<div class="modal-body">' +
                    '				<form class="form-horizontal" role="form">' +
                    '					<div class="form-group">' +
                    '						<label class="col-md-2 control-label">Name</label>' +
                    '						<div class="col-md-10 controls">' +
                    '							<input name="text" class="form-control input-md" type="text" value="" />' +
                    '						</div>' +
                    '					</div>' +
                    '					<div class="form-group">' +
                    '						<label class="col-md-2 control-label">Email</label>' +
                    '						<div class="col-md-10 controls">' +
                    '							<input name="email" class="form-control input-md" type="text" placeholder="email@example.com" value="" />' +
                    '						</div>' +
                    '					</div>' +
                    '				</form>' +
                    '			</div>' +
                    '			<div class="modal-footer">' +
                    '				<a href="#" class="btn btn-md btn-primary">OK</a>' +
                    '				<a href="#" class="btn btn-md btn-default" data-dismiss="modal">Close</a>' +
                    '			</div>' +
                    '		</div>' +
                    '	</div>' +
                    '</div>';
            $('body').prepend(s);
            var $modal = $('body').children(':first');
            var sel = delegate.getSelection();
            if (sel != '') {
                $modal.find('input[name=text]').val(sel);
            }
            $modal.modal('show');
            $modal.find('.btn-primary').click(function () {
                var text = $.trim($modal.find('input[name=text]').val());
                var email = $.trim($modal.find('input[name=email]').val());
                if (email == '') email = 'email@example.com';
                if (email.indexOf('mailto:') === -1) email = 'mailto:' + email;
                if (text == '') text = email;
                delegate.paste('[' + text + '](' + email + ')');
                $modal.modal('hide');
            });
            $modal.on('hidden.bs.modal', function () {
                $modal.remove();
            });
        },
        //上传图片,待测试 
        image: function (delegate) {
            var getObjectURL = function (file) {
                var url = '';
                if (window.createObjectURL != undefined) // basic
                    url = window.createObjectURL(file);
                else if (window.URL != undefined) // mozilla(firefox)
                    url = window.URL.createObjectURL(file);
                else if (window.webkitURL != undefined) // webkit or chrome
                    url = window.webkitURL.createObjectURL(file);
                return url;
            };
            var s = '<div class="modal fade" style="overflow-y:hidden;" data-backdrop="static" role="dialog" aria-hidden="true">' +
                    '	<div class="modal-dialog">' +
                    '		<div class="modal-content">' +
                    '			<div class="modal-header">' +
                    '				<button type="button" class="close" data-dismiss="modal">&times;</button>' +
                    '				<h3 class="modal-title">Insert Image</h3>' +
                    '			</div>' +
                    '			<div class="modal-body">' +
                    '				<div style="width:530px;"> ' +
                    '					<div class="alert alert-danger hidden"></div>' +
                    '					<div class="row">' +
                    '						<div class="col-md-5" style="width:230px"> ' +
                    '							<label class="control-label">Preview</label>' +
                    '							<div class="preview" style="width:200px;height:150px;border:solid 1px #ccc;padding:4px;margin-top:3px;background-repeat:no-repeat;background-position:center center;background-size:cover;"></div>' +
                    '						</div>' +
                    '						<div class="col-md-7" style="width:300px"> ' +
                    '							<form class="form-horizontal" role="form">' +
                    '					          <div class="form-group" style="margin-bottom: 5px;">' +
                    '						        <label class="control-label">Text</label>' +
                    '								<input name="text" type="text" class="form-control input-md" value="" />' +
                    '					          </div>' +
                    '					          <div class="form-group" style="margin-bottom: 5px;">' +
                    '								<label class="control-label">File</label>' +
                    '								<input name="file" type="file" />' +
                    '					          </div>' +
                    '					          <div class="form-group" style="margin-bottom: 5px;">' +
                    '								<label class="control-label">Progress</label>' +
                    '								<div class="progress progress-striped active" >' +
                    '									<div class="bar" style="width:0%;"></div>' +
                    '								</div>' +
                    '					          </div>' +
                    '							</form>' +
                    '						</div>' +
                    '					</div>' +
                    '				</div>' +
                    '			</div>' +
                    '			<div class="modal-footer" style="margin-top: 0;">' +
                    '				<button class="btn btn-md btn-primary">OK</button>' +
                    '				<button class="btn btn-md btn-cancel" data-dismiss="modal">Close</button>' +
                    '			</div>' +
                    '		</div>' +
                    '	</div>' +
                    '</div>';
            $('body').prepend(s);
            var $modal = $('body').children(':first');
            var $form = $modal.find('form');
            var $text = $modal.find('input[name="text"]');
            var $file = $modal.find('input[name="file"]');
            var $prog = $modal.find('div.bar');
            var $preview = $modal.find('div.preview');
            var $alert = $modal.find('div.alert');
            var $status = {
                'uploading': false
            };
            $modal.modal('show');
            //校验文件类型
            $file.change(function () {
                // clear error:
                $alert.text('').removeClass('alert-danger show').addClass('hidden');
                //$alert.text('');

                var f = $file.val();
                if (!f) {
                    $preview.css('background-image', '');
                    return;
                }
                var lf = $file.get(0).files[0];
                var ft = lf.type;
                console.log('ft:' + ft);
                if (ft == 'image/png' || ft == 'image/jpeg' || ft == 'image/gif') {
                    $preview.css('background-image', 'url(' + getObjectURL(lf) + ')');
                    if ($text.val() == '') {
                        // extract filename without ext:
                        var pos = Math.max(f.lastIndexOf('\\'), f.lastIndexOf('/'));
                        if (pos > 0) {
                            f = f.substring(pos + 1);
                        }
                        var pos = f.lastIndexOf('.');
                        if (pos > 0) {
                            f = f.substring(0, pos);
                        }
                        $text.val(f);
                    }
                } else {
                    $preview.css('background-image', '');
                    //$alert.text('Not a valid web image.');
                    $alert.text('Not a valid web image.').removeClass('hidden').addClass('alert-danger show');
                    console.log('Not a valid web image.');
                }
            });
            
            var cancel = function () {
                if ($status.uploading) {
                    if (!confirm('File is uploading, are you sure you want to cancel it?')) {
                        return;
                    }
                    if ($status.uploading) {
                        $status.xhr.abort();
                    }
                }
                $modal.modal('hide');
            };
            $modal.find('button.close').click(cancel);
            $modal.find('button.btn-cancel').click(cancel);
            $modal.find('.btn-primary').click(function () {
                // clear error:
                $alert.removeClass('alert-danger show').addClass('hidden').text('');
                // upload file:
                var f = $file.val();
                if (!f) {
                    $alert.text('Please select file.').removeClass('hidden').addClass('alert-danger show');
                    return;
                }
                var $url = delegate.getOption('upload_image_url');
                if (!$url) {
                    $alert.text('upload_image_url not defined.').removeClass('hidden').addClass('alert-danger show');
                    return;
                }
                try {
                    var text = $text.val();
                    var lf = $file.get(0).files[0];
                    // send XMLHttpRequest2:
                    var fd = null;
                    var form = $form.get(0);
                    try {
                        fd = form.getFormData();
                    } catch (e) {
                        fd = new FormData(form);
                    }
                    var xhr = new XMLHttpRequest();
                    xhr.upload.addEventListener('progress', function (evt) {
                        if (evt.lengthComputable) {
                            var percent = evt.loaded * 100.0 / evt.total;
                            $prog.css('width', percent.toFixed(1) + '%');
                        }
                    }, false);
                    xhr.addEventListener('load', function (evt) {
                        var r = $.parseJSON(evt.target.responseText);
                        if (r.error) {
                            $alert.removeClass('hidden').addClass('alert-danger show').text(r.message || r.error);
                            $status.uploading = false;
                        } else {
                            // upload ok!
                            delegate.unselect();
                            var s = '\n![' + text.replace('[', '').replace(']', '') + '](' + r.url + ')\n';
                            delegate.paste(s);
                            delegate.setSelection(delegate.getCaretPosition() + 1, delegate.getCaretPosition() + s.length - 1);
                            $modal.modal('hide');
                        }
                    }, false);
                    xhr.addEventListener('error', function (evt) {
                        $alert.removeClass('hidden').addClass('alert-danger show').text('Error: upload failed.');
                        $status.uploading = false;
                    }, false);
                    xhr.addEventListener('abort', function (evt) {
                        $status.uploading = false;
                    }, false);
                    xhr.open('post', $url);
                    xhr.send(fd);
                    $status.uploading = true;
                    $status.xhr = xhr;
                    $file.attr('disabled', 'disabled');
                } catch (e) {
                    $alert.removeClass('hidden').addClass('alert-danger show').text('Could not upload.');
                }
                $(this).attr('disabled', 'disabled');
            });
            $modal.on('hidden.bs.modal', function () {
                $modal.remove();
            });
        },
        //预览 
        preview: function (delegate) {
            if (!delegate.is_preview) {
                delegate.is_preview = true;
                delegate.enableAllButtons(false);
                delegate.enableButton('preview', true);
                delegate.$textarea.hide();
                delegate.$preview.html('<div style="padding:3px;">' + markdown2html(delegate.$textarea.val()) + '</div>').show();
            } else {
                delegate.is_preview = false;
                delegate.enableAllButtons(true);
                delegate.$preview.html('').hide();
                delegate.$textarea.show();
            }
        },
        //全屏编辑
        fullscreen: function (delegate) {
            if (!delegate.is_full_screen) {
                delegate.is_full_screen = true;
                delegate.enableButton('preview', false);
                var s = '<div style="overflow:auto;overflow-y:none;position:fixed;display:none;z-index:1000;top:0;right:0;bottom:0;left:0;background-color:#ffffff;">' +
                        '	<div style="z-index:1010;width:auto;padding:0;margin-right:0;margin-left:0;">' +
                        '		<div style="padding: 0;">' +
                        '			<div class="left" style="margin:0;padding:0 2px 2px 2px;float:left;"></div>' +
                        '			<div class="right" style="float:left;padding:0;margin:0;border-left:solid 1px #ccc;overflow:scroll;"></div>' +
                        '		</div>' +
                        '	</div>' +
                        '</div>';
                $('body').prepend(s);
                var $modal = $('body').children(':first');
                console.log($modal.html());
                var $left = $modal.find('div.left');
                var $right = $modal.find('div.right');
                // $modal.modal('show');
                $modal.show();
                delegate.$fullscreen = $modal;
                //提到前面，防止自适应导致宽度变化
                // store old width and height for textarea: //记录旧时textarea大小
                //delegate.$textarea_old_width = delegate.$textarea.css('width'); 
                //delegate.$textarea_old_height = delegate.$textarea.css('height');
                delegate.$textarea_old_width = delegate.$textarea.innerWidth();
                delegate.$textarea_old_height = delegate.$textarea.innerHeight();
                delegate.$toolbar.appendTo($left);
                delegate.$textarea.appendTo($left);
                // bind resize:
                delegate.$fn_resize = function () {
                    var w = $(window).width();
                    var h = $(window).height();
                    if (w < 960) {
                        w = 960;
                    }
                    if (h < 300) {
                        h = 300;
                    }
                    var rw = parseInt(w / 2);
                    var $dom = delegate.$fullscreen;
                    $dom.css('width', w + 'px');
                    $dom.css('height', h + 'px');
                    $dom.find('div.right').css('width', (rw - 1) + 'px').css('height', h + 'px');
                    $dom.find('div.left').css('width', (w - rw - 4) + 'px').css('height', h + 'px');
                    delegate.$textarea.css('width', (w - rw - 18) + 'px').css('height', (h - 64) + 'px');
                };
                $(window).bind('resize', delegate.$fn_resize).trigger('resize');
                $right.html(markdown2html(delegate.getText()));
                // bind text change:
                delegate.$n_wait_for_update = 0;
                delegate.$b_need_update = false;
                delegate.$fn_update_count = function () {
                    if (delegate.$b_need_update && delegate.$n_wait_for_update > 10) {
                        delegate.$b_need_update = false;
                        delegate.$n_wait_for_update = 0;
                        $right.html(markdown2html(delegate.getText()));
                    } else {
                        delegate.$n_wait_for_update++;
                    }
                };
                setInterval(delegate.$fn_update_count, 100);
                delegate.$fn_keypress = function () {
                    console.log('Keypress...');
                    delegate.$b_need_update = true; // should update in N seconds
                    delegate.$n_wait_for_update = 0; // reset count from 0
                };
                delegate.$textarea.bind('keypress', delegate.$fn_keypress);
            } else {
                // unbind:
                delegate.$textarea.unbind('keypress', delegate.$fn_keypress);
                $(window).unbind('resize', delegate.$fn_resize);
                delegate.$fn_keypress = null;
                delegate.$fn_resize = null;
                delegate.$fn_update_count = null;

                delegate.is_full_screen = false;
                delegate.enableButton('preview', true);
                delegate.$toolbar.appendTo(delegate.$container);
                delegate.$preview.appendTo(delegate.$container);
                delegate.$textarea.appendTo(delegate.$container);
                // delegate.$fullscreen.modal('hide');
                delegate.$fullscreen.hide();
                delegate.$fullscreen.remove();
                // restore width & height:
                delegate.$textarea.css('width', delegate.$textarea_old_width).css('height', delegate.$textarea_old_height);
            }
        },

    };

    $.fn.markdown = function (option) {
        return this.each(function () {
            var $this = $(this);
            var data = $this.data('markdown'); //获取属性'data-markdown'的值 http://www.w3school.com.cn/jquery/data_jquery_data.asp
            var options = $.extend({}, $.fn.markdown.defaults, typeof option == 'object' && option);
            if (!data) {
                data = new Markdown(this, options, commands); //commands 定义各个按钮的处理函数
                $this.data('markdown', data);
            }
        });
    };

    $.fn.markdown.defaults = {
        buttons: [
            'heading',
            '|',
            'bold', 'italic', 'ul', 'quote',
            '|',
            'link', 'email',
            '|',
            'image', 'video',
            '|',
            'preview',
            '|',
            'fullscreen',
        ],
        tooltips: {
            'heading': 'Set Heading',
            'bold': 'Bold',
            'italic': 'Italic',
            'ul': 'Unordered List',
            'quote': 'Quote',
            'link': 'Insert URL',
            'email': 'Insert email address',
            'image': 'Insert image',
            'video': 'Insert video',
            'preview': 'Preview content',
            'fullscreen': 'Fullscreen mode',
        },
        icons: {
            'heading': 'glyphicon glyphicon-font',
            'bold': 'glyphicon glyphicon-bold',
            'italic': 'glyphicon glyphicon-italic',
            'ul': 'glyphicon glyphicon-list',
            'quote': 'glyphicon glyphicon-comment',
            'link': 'glyphicon glyphicon-globe',
            'email': 'glyphicon glyphicon-envelope',
            'image': 'glyphicon glyphicon-picture',
            'video': 'glyphicon glyphicon-facetime-video',
            'preview': 'glyphicon glyphicon-eye-open',
            'fullscreen': 'glyphicon glyphicon-fullscreen glyphicon-white',
        },
        upload_image_url: '',
        upload_file_url: '',
    };

    $.fn.markdown.Constructor = Markdown;

}(window.jQuery);