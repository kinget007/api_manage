$(document).ready(function () {

    /***** Bubble text *****/

    function BubbleText() {

        var msgSpeed = 3000;
        var textArray = ["I think<br/>I'm lost!", "Why!!!"];


        if (typeof bubbleMsg != 'undefined')
            textArray = bubbleMsg;

        if (typeof bubbleMsgSpeed != 'undefined')
            msgSpeed = bubbleMsgSpeed;

        var $bubbleText = $(".bubble-text");

        var counter = 0;

        function ChangeText() {
            $bubbleText.html(textArray[counter]);

            counter++;

            if (counter >= textArray.length) counter = 0;
        }

        ChangeText();

        setInterval(ChangeText, msgSpeed);

    }

    BubbleText();

    /***** Tooltip *****/

    //Adjust tooltips position
    $(".tooltip").each(function () {
        var parentW = $(this).parent().outerWidth();

        var hw = ($(this).width() - parentW) / 2;

        $(this).css('left', -hw);
    });

    $('.navigation-links li').hover(
    function () {
        var $this = $(this);
        $this.find('.tooltip').stop().css({ 'display': 'block', 'opacity': 0 }).animate({ opacity: 1 }, 300);
    },
    function () {
        var $this = $(this);
        $this.find('.tooltip').stop().animate({ opacity: 0 }, 300);
    }
    );

    /***** Search form *****/
    SearchForm();


    /***** Clouds Animation *****/
    Clouds();

});

function Clouds() {

    var $container = $('#clouds'),
        $clouds    = $container.find('img'),
        containerWidth  = $container.width(),
        containerHeight = $container.height(),
        $canvas = $('<canvas></canvas>');


    $container.append($canvas);

    var canvas = $canvas.get(0),
           ctx = canvas.getContext('2d');

    ctx.canvas.width  = containerWidth;
    ctx.canvas.height = containerHeight;

    $(window).resize(function () {
        containerWidth  = $container.width();
        containerHeight = $container.height();

        ctx.canvas.width  = containerWidth;
        ctx.canvas.height = containerHeight;
    });

    //Trigger the animation when all images are loaded
    ImagesLoaded($clouds, function () {

        var objects = new Array();

        //Get speed of each cloud
        $clouds.each(function (i) {
            var $this = $(this);

            objects[i] = {
                image: this,
                speed: parseFloat($this.attr('data-speed')),
                width: $this.width(),
                height: $this.height(),
                x: $this.position().left,
                y: $this.position().top
            };

        });

        $clouds.hide();

        var start = new Date().getTime(), delta = 1;

        //Animation loop
        function loop() {
            //call the update function
            update(delta / 1000);

            var now = new Date().getTime();
            delta = now - start;
            start = now;

            window.setTimeout(loop, (25 - (delta - 25)));
        }

        window.setTimeout(loop, 25);

        //Update the animation
        function update(delta) {
            //Clear the canvas
            ctx.clearRect(0, 0, containerWidth, containerHeight);

            for (i = 0; i < objects.length; i++) {
                var obj = objects[i];

                obj.x += obj.speed * delta;

                if (obj.x >= containerWidth) {
                    obj.x = -obj.width;

                    //Generate new y position based on random value
                    var maxY = 230 - obj.height - 10;
                    obj.y = Math.floor((Math.random() * maxY) + 20);
                }

                ctx.drawImage(obj.image, obj.x, obj.y);
            }


        }

    });

}

//Triggers a callback function when all images are loaded in the array
function ImagesLoaded($images, callback) {
    var loaded = 0;

    $images.each(function () {
        var $this = $(this);

        if (this.complete === true) 
            OnLoad();
        
        $this.load(OnLoad);

        // cached images don't fire load sometimes, so we reset src.
        if (this.complete === undefined || this.complete === false) {
            var src = image.src;
            // webkit hack from http://groups.google.com/group/jquery-dev/browse_thread/thread/eee6ab7b2da50e1f
            // data uri bypasses webkit log warning (thx doug jones)
            this.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==";
            this.src = src;
        }

    });

    function OnLoad() {
        loaded++;

        if (loaded == $images.length) callback();
    }

}