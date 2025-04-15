var ready;

ready = document.querySelectorAll('.bootstrap-multiselect').forEach((el)=>{
    let settings = {};
    settings.maxItems = null;
    new TomSelect(el,settings);
});

$(document).on('turbolinks:load', ready);
