if (Shopify.checkout.shipping_rate.title.toLowerCase().includes('urbit')) {
  $.ajax({
      type: "POST",

      url: "https://7692dd1e.ngrok.io/urbit_valid",
      crossDomain: true,
      headers: {
              "Access-Control-Allow-Origin": "*",
              'Access-Control-Allow-Methods':'POST',
              'Access-Control-Allow-Headers':'application/json'
            },
      data:  {
        cart_token: Shopify.checkout.line_items[0].properties.urbit_token
      },
      success: function(data) {
        console.log(data.answer)

      },
      error : function(resultat, statut, erreur){console.log(statut, erreur)},
      dataType: 'json'
  });
}
