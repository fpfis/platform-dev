jQuery(function($){ 
  $(document).ready( function(){ 
    //Add class to switcher column
    $("#feature-set-admin-form .form-type-checkbox").addClass('switch');
    
    //Add class to row if button is disabled
    $("#feature-set-admin-form tr .switch")
      .filter('.form-disabled')
      .closest('tr')
      .addClass('form-disabled');
  
    //Add switcher before checkbox and hide checkbox
    /*$("#feature-set-admin-form .form-checkbox")
      .css('opacity',0)
      .filter(':checked')
        .before('<label class="cb-enable selected"><span><i class="icon-ok icon-white"></i></span></label><label class="cb-disable"><span><i class="icon-remove icon-white"></i></span></label>')
      .end()
      .not(':checked')
        .before('<label class="cb-enable"><span><i class="icon-ok icon-white"></i></span></label><label class="cb-disable selected"><span><i class="icon-remove icon-white"></i></span></label>');
    */
    $("#feature-set-admin-form .form-checkbox").each(function() {
      $this = $(this);
      //Check if the feature has been enabled
      if ($this.is(':checked')) {
        var html_before = '<label class="cb-enable selected"><span><i class="icon-ok icon-white"></i></span></label><label class="cb-disable"><span><i class="icon-remove icon-white"></i></span></label>';
      } else {
        var html_before = '<label class="cb-enable"><span><i class="icon-ok icon-white"></i></span></label><label class="cb-disable selected"><span><i class="icon-remove icon-white"></i></span></label>';
      }     
      
      $this
        .before(html_before)
        .css('opacity',0);
    });

    //Manage click on a row
    $('#feature-set-admin-form').on('click', 'tr', function() {
      $(this)
        .not('.form-disabled')
          .find('.switch')
            .toggleClass('pending')
            .children('label')
              .toggleClass('selected')
            .end()
            .children('.form-checkbox')
              .each(function() {
                $this = $(this);
                if ($this.is(':checked')) {
                  $this.attr('checked', false);
                } else {
                  $this.attr('checked', true);
                }               
              }); 
    });
  });
});