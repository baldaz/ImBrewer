$(document).ready(function() {

    var max_fields = 10; //maximum input boxes allowed
    var m_wrapper = $(".input_fields_wrap_malt"); //Fields wrapper
    var h_wrapper = $(".input_fields_wrap_hop");
    var add_button = $(".add_field_button_malt"); //Add button ID
    var add_h_button = $(".add_field_button_hop");

    var x = 1; //initlal text box count
    $(add_button).click(function(e){ //on add input button click
        e.preventDefault();
        if(x < max_fields){ //max input box allowed
            x++; //text box increment
            $(m_wrapper).append('<div class="form-group"><label for="fermentable_'+x+'" class="col-xs-1 control-label">Malt #'+x+'</label><div class="col-xs-2"><select class="form-control input-sm" id="fermentable_'+x+'" name="fermentable_[]"><option>Pilsener</option><option>Cara pils</option><option>Flaked corn</option></select></div><label for="kg_fermentable_'+x+'" class="col-xs-1 control-label">Kg</label><div class="col-xs-2"><input type="text" class="form-control input-sm" id="kg_fermentable_'+x+'" name="kg_fermentable_[]" /></div><div class="col-xs-1"><button class="btn btn-xs remove_field"><i class="fa fa-minus-circle"></i></button></div></div>'); //add input box
        }
    });

    $(m_wrapper).on("click",".remove_field", function(e){ //user click on remove text
        e.preventDefault(); $(this).parent('div').parent('div').remove(); x--; // parent.parent to prevent col-xs-1 to be the only one removed
    });

    var h = 1; //initlal text box count
    select="";
    var jh = 0;
      $.ajax({
          type: "POST",
          url: "/json/hops",
          success:function(rubydata){
            $.each(rubydata, function(key, value){
              select += '<option value='+key+'>'+value.name+'</option>';
            })
          },
          error:function(request){
            alert('errore');
          },
        });
        $(add_h_button).click(function(e){
          e.preventDefault();
          if(h < max_fields){ //max input box allowed
              h++; //text box increment
              $(h_wrapper).append('<div class="form-group"><label for="hop_name_'+h+'" class="col-xs-1 control-label">Hop #'+h+'</label><div class="col-xs-2"><select class="form-control input-sm" id="hop_name_'+h+'" name="hop_name_[]">'+select+'</select></div><label for="hop_grams_'+h+'" class="col-xs-1 control-label">Grams</label><div class="col-xs-1"><input type="text" class="form-control input-sm" id="hop_grams_'+h+'" name="hgrams[]" /></div><label for="alpha_acid_'+h+'" class="col-xs-1 control-label">Alpha acid</label><div class="col-xs-1"><input type="text" class="form-control input-sm" id="alpha_acid_'+h+'" name="aa[]"></div><label for="boil_time_'+h+'" class="col-xs-1 control-label">Boil time</label><div class="col-xs-1"><input type="text" class="form-control input-sm" id="boil_time_'+h+'" name="btime[]"></div><div class="col-xs-1"><button class="btn btn-xs remove_field"><i class="fa fa-minus-circle"></i></button></div></div>'); //add input box
          }
        });

    $(h_wrapper).on("click",".remove_field", function(e){ //user click on remove text
        e.preventDefault(); $(this).parent('div').parent('div').remove(); h--;
    });

  // login form

  $(".flp label").each(function(){
    var sop = '<span class="ch">';
    var scl = '</span>';
    $(this).html(sop + $(this).html().split("").join(scl+sop)+scl);
    $(".ch:contains(' ')").html("&nbsp;");
  });

  var d;

  $(".flp input").focus(function(){
    var tm = $(this).outerHeight()/2*-1+"px";
    $(this).next().addClass("focussed").children().stop(true).each(function(i){
      d = i * 50;
      $(this).delay(d).animate({top:tm},200,'easeOutBack');
    })
  });

  $(".flp input").blur(function(){
    if($(this).val() == "")
      {
        $(this).next().removeClass("focussed").children().stop(true).each(function(i){
          d = i * 50;
          $(this).delay(d).animate({top:0},500,'easeInOutBack');
        })
      }
  });

  var current_fs, next_fs, previous_fs;
  var left, opacity, scale;
  var animating;

  $(".next").click(function(){
    if(animating) return false;
    animating = true;

    current_fs = $(this).parent();
    next_fs = $(this).parent().next();

    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("pbactive");

    next_fs.show();
    current_fs.animate({opacity:0}, {
      step:function(now,mx){
        scale = 1 - (1 - now) * 0.2;
        left = (now * 50) + "%";
        opacity = 1 - now;
        current_fs.css({'transform':'scale('+scale+')'});
        next_fs.css({'left':left,'opacity':opacity});
      },
      duration: 800,
      complete:function(){
        current_fs.hide();
        animating = false;
      },
      easing:'easeOutBack'
    });
  });

  $(".previous").click(function(){
    if(animating) return false;
    animating = true;

    current_fs = $(this).parent();
    previous_fs = $(this).parent().prev();

    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("pbactive");

    previous_fs.show();
    current_fs.animate({opacity:0},{
      step:function(now, mx){
        scale = 0.8 + (1 - now) * 0.2;
        left = ((1 - now) * 50) + "%";
        opacity = 1 - now;
        current_fs.css({'left':left});
        previous_fs.css({'transform':'scale('+scale+')','opacity':opacity});
      },
      duration:800,
      complete:function(){
        current_fs.hide();
        animating = false;
      },
      easing:'easeInOutBack'
    });
  });

  // $(".submit").click(function(){
  //   return false;
  // })

  $("#specform").on('change', function(){
    var gm, aa, bt, bs;

     $("#recipe").val(null);

    gm = $("input[name='hgrams[]']").val();
    aa = $("input[name='aa[]']").val();
    bt = $("input[name='btime[]']").val();
    bs = $("#batch_size").val();
    og = $("#og").val();

    if(gm !== '' && aa !== '' &&
      bt !== '' && bs !== ''){
        $.ajax({
          type: "POST",
          url: "/calculations/ibu",
          data: { hop_grams:gm, alpha_acid:aa, boil_time:bt, batch_size:bs, og:og },
          success:function(rubydata){
            $("#output").html(rubydata);
            // $("#hid").val(rubydata);
          },
          error:function(request){
            $("#output").html(request.responseText);
          },
        });
      }
    });

    $("#rcpform").change(function() {
      var rcp = $("#recipe").val();
      var input = $('input');
      $("#rcpname").html($('#recipe :selected').text());
      $.ajax({
        type: "POST",
        url: "/recipes/" + rcp,
        success:function(rcpdata) {
          $("#output").html(rcpdata.ibu);
          $("#og").val(rcpdata.og);
          $("#fg").val(rcpdata.fg);
          $("#batch_size").val(rcpdata.batch);
          $("#style").val(rcpdata.style);
          input.trigger('input');
          // scope.val(rcpdata.OG);
        },
        // error:function(request) {

          // alert(request.responseText);
        // },
      });
    });
    // using attach event handler to bubblin propagation
    $('#myTabContent').on('click','a', function(e) {
      e.preventDefault();
      var id = $(this).attr('id');
      var nextId = parseInt(id) + 1;
      var prevId = parseInt(id) - 1;
      var nav = '<nav><ul class="pager"><li class="previous"><a href="#" id=' + prevId + '><span aria-hidden="true">&larr;</span> Previous</a></li><li class="next"><a href="#" id=' + nextId +'>Next <span aria-hidden="true">&rarr;</span></a></li></ul></nav>';
      $.ajax({
        type: 'POST',
        url : '/recipes/' + id,
        success:function(rcpdata) {
          var panel = '<div class="panel panel-default"><div class="panel-heading">' + rcpdata.name + '</div><div class="panel-body">';
          var desc = '<article><h4>Description:</h4><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin consequat at nisl nec euismod. Morbi imperdiet ac ante non sollicitudin. Pellentesque porttitor erat libero, eu hendrerit lacus luctus bibendum. Duis eu sagittis purus. Duis varius augue a tempor aliquet. Curabitur vitae venenatis orci. Maecenas dictum lacus vel cursus suscipit.</p></article>';
          $('#myTabContent').html(panel + '<div class="col-lg-10 col-md-10 col-xs-10">IBU:<span class="resultset">' + rcpdata.ibu + '</span>Original Gravity:<span class="resultset">' + rcpdata.og + '</span>Final Gravity:<span class="resultset">' + rcpdata.fg + '</span>Batch:<span class="resultset">' + rcpdata.batch +' l.</span>Alcool:<span class="resultset">' + rcpdata.abv + ' %</span>'  + desc + '</div></div></div>' + nav);
        },
        error:function(req) {
          // $('#myTabContent').html('req.responseText');
          window.location = '/recipes'
        }
      });
    });
});
