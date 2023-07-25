ResizableSidebar.prototype.add_handle = function () {
    this.$row.addClass('has-resizable-content-left');

    var $handle = $('<input>').attr('type', 'range');
    $handle.attr('value', 25);
    $handle.attr('max', 76);
    $handle.attr('min', 12);
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
            Math.max(e.clientX - self.$row.offset().left, 200),
            self.$row.width() - 300
        );

        self.$sidebar.css('width', width);
        self.$content_pane.css('width', self.$row.width() - width);
    }).on('mouseup', function (e) {
        self.isResizing = false;
    });

    // ANW-1316: Make resizable input slider work with keyboard commands alone
    $(document).on('keydown', function (e) {
        if (!self.isResizing) {
            return;
        }

        const width = Math.min(
            Math.max(self.$row.width() * e.target.value / 100, 200),
            self.$row.width() - 300
        );

        self.$sidebar.css('width', width);
        self.$content_pane.css('width', self.$row.width() - width);
    }).on('keyup', function (e) {
        self.isResizing = false;
    });
};
