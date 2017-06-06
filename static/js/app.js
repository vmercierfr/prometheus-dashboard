$(document).ready(function()
{
    $('#alerts thead th').each( function () {
        var title = $(this).text();
        if (title != '' && title != 'Started') {
            $(this).html( '<input type="text" class="searchfield" placeholder="'+title+'" />' );
        }
    } );

    var table = $("#alerts").DataTable({
        "paging": false, // Disable paging
        "order": [[ 4, "desc" ]], // Sort by most recent event
        "sDom": '<"top">rt<"bottom"i><"clear">',
        "columnDefs": [ {
            "targets": 'no-sort',
            "orderable": false,
        } ]
    });

    // Apply the search
    table.columns().every( function () {
        var that = this;

        $( 'input', this.header() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                    .search( this.value )
                    .draw();
            }
        } );
    } );
}
);