ResizableSidebar.prototype.add_handle = function () {
    this.$row.addClass('has-resizable-content-left');

    var $handle = $('<input>').attr('type', 'range');
    $handle.attr('value', 25);
    $handle.attr('max', 75);
    $handle.attr('min', 25);
    $handle.attr('aria-label', 'resizable sidebar handle');
    $handle.attr('id', 'accessible_slider');
    $handle.addClass('resizable-sidebar-handle');

    this.$sidebar.append($handle);

    this.$handle = $handle;
};

ResizableSidebar.prototype.bind_events = function() {
    var self = this;

    self.$handle.on('mousedown keydown', function (e) {
        self.isResizing = true;
    });

    $(document).on('mousemove', function (e) {
        if (!self.isResizing) {
            return;
        }

        var width = Math.min(
            Math.max(
                e.clientX - self.$row.offset().left,
                self.$row.width() * self.$handle.attr('min') / 100
            ),
            self.$row.width() * self.$handle.attr('max') / 100
        );

        self.$sidebar.css('width', width);
        self.$content_pane.css('width', self.$row.width() - width);
    }).on('mouseup', function (e) {
        self.isResizing = false;
    });

    $(document).on('keydown', function (e) {
        if (!self.isResizing) {
            return;
        }

        const width = Math.min(
            Math.max(
                self.$row.width() * e.target.value / 100,
                self.$row.width() * self.$handle.attr('min') / 100
            ),
            self.$row.width() * self.$handle.attr('max') / 100
        );

        self.$sidebar.css('width', width);
        self.$content_pane.css('width', self.$row.width() - width);
    }).on('keyup', function (e) {
        self.isResizing = false;
    });
};
