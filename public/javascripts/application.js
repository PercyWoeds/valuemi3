
// Document ready (on load)
  function documentReady() {
    fixPngs();
  	tableColors();
  	textClasses();
  	dropdowns();
  }

  // Dropdowns
  function dropdowns() {
    $(".dropdown").each(function() {
      var id = $(this).attr("id");
  		var part = id.split("_");
  		part = part[1];
  		
  		var id_menu = "menu_" + part;
  		
  		var offset = $(this).offset();
  		
  		$("#" + id_menu).css({"left": (offset.left - 20) + "px", "top": (offset.top + 12) + "px"});
  		
  		$(this).click(function() {
  		  return false;
  	  });
  		
  		$(this).mouseover(function() {
  			$("#" + id_menu).css("display", "block");
  		});
  		
  		$("#" + id_menu).mouseover(function() {
  			$("#" + id_menu).css("display", "block");
  		});
  		
  		$(this).mouseout(function() {
  			$("#" + id_menu).css("display", "none");
  		});
  		
  		$("#" + id_menu).mouseout(function() {
  			$("#" + id_menu).css("display", "none");
  		});
    });
  }

  // Is Numeric support
  function isNumeric(input) {
      return (input - 0) == input && input.length > 0;
  }

  // Shows loading box
  function showLoading() {
  	$('#loading').centerInClient();
  	$('#loading').css("display", "block");
  }

  // Hides loading box
  function hideLoading() {
  	$("#loading").fadeOut("fast");
  }

  // Shows or hides aa div
  function toggle(id) {
    if($("#" + id).css("display") == "none") {
      $("#" + id).css("display", "block");
    } else {
      $("#" + id).css("display", "none");
    }
  }

  // Arregla PNGs para IE6
  function fixPngs() {
  	$('body').supersleight();
  }

  // Alterna colores de rows de una tabla
  function tableColors() {
  	$("tr:even").css("background-color", "#dddddd");
  	$("tr:odd").css("background-color", "#ffffff");
  	$("table.portada tr").css("background-color", "#ffffff");
  	
  	$("tr:even").mouseover(function() {
  		$(this).css("background-color", "yellow");
  	});
  	
  	$("tr:even").mouseout(function() {
  		$(this).css("background-color", "#dddddd");
  	});
  	
  	$("tr:odd").mouseover(function() {
  		$(this).css("background-color", "yellow");
  	});
  	
  	$("tr:odd").mouseout(function() {
  		$(this).css("background-color", "#ffffff");
  	});
  }

  // Agrega clase de text a todos los textfields
  function textClasses() {
    $('input[type=submit]').addClass('button');
    $('input[type=button]').addClass('button');
    
  	$('input[type=text]').addClass('text');
  	$('input[type=password]').addClass('text');
    
    $('.small input[type=text]').addClass('small');
    $('.small select').addClass('small');
    $('.small input[type=submit]').addClass('small');
    $('.small input[type=button]').addClass('small');
  }

  // Shows the remote window
  function showRemote() {
    $("#remote").centerInClient();
    $("#remote").css("display", "block");
    documentReady();
  }

  // Hides the remote window
  function hideRemote() {
    $("#remote").css("display", "none");
  }

  // Displays html in remote window
  function displayRemote(html) {
    html = '<div class="fright"><a href="#" onclick="hideRemote(); return false;">X</a></div>' + html + '<div class="break"><!-- i --></div>';
    $("#remote").html(html);
  }

  // Add an item to a product kit
  function addItemToKit() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#products_kit_company_id").val();
      var item_id = $("#ac_item_id").val();
      var quantity = $("#ac_item_quantity").val();
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Please enter a valid quantity");
      } else {
        if($.inArray(item_id, items_arr) == -1) {
          $("#items").val($("#items").val() + "," + item_id);
          $("#items_quantities").val($("#items_quantities").val() + "," + quantity);
          listItemsKit();
          
          $("#ac_item_id").val("");
          $("#ac_item").val("");
          $("#ac_item_quantity").val("1");
        } else {
          alert("The item already exists in the product kit.");
        }
      }
    } else {
      alert("Please find a product to add first.");
    }
  }
  

  // List items in a kit
  function listItemsKit() {
    var items = $("#items").val();
    var items_quantities = $("#items_quantities").val();
    var company_id = $("#products_kit_company_id").val();
    
    $.get('/products_kits/list_items/' + company_id, {
      items: items,
      items_quantities: items_quantities
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

  // Removes an item from a kit
  function removeItemFromKit(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(items_arr[i] != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsKit();
  }

  // Update price total for invoice
  function updateItemTotal() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {
      
      var total = quantity * price ;
      
      total -= total * (discount / 100);

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }


  // Add an item to a product kit
  function addItemToInvoice() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#invoice_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var discount = $("#ac_item_discount").val();    
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Please enter a valid quantity");
      } else if(price == "" || !isNumeric(price)) {
        alert("Please enter a valid price");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Please enter a valid discount");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);
        
        listItemsInvoice();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        updateItemTotal();
      }
    } else {
      alert("Please find a product to add first.");
    }
  }

  // List items in a kit
  function listItemsInvoice() {
    var items = $("#items").val();
    var company_id = $("#invoice_company_id").val();
    
    $.get('/invoices/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

  // Update price total for invoice
  function updateItemTotal2() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {
      var total = quantity * price;
      total -= total * (discount / 100);

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }

  // Add an item to a product kit
  function addItemToInvoice2() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#factura_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var discount = $("#ac_item_discount").val();
      
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Please enter a valid quantity");
      } else if(price == "" || !isNumeric(price)) {
        alert("Please enter a valid price");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Please enter a valid discount");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemsInvoice2();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        updateItemTotal2();
      }
    } else {
      alert("Please find a product to add first.");
    }
  }

  // List items in a kit
  function listItemsInvoice2() {
    var items = $("#items").val();
    var company_id = $("#factura_company_id").val();
    
    $.get('/facturas/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  // Update price total for invoice
  function updateItemdelivery() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {
      var total = quantity * price;
      total -= total * (discount / 100);

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("$0.00");
    }
  }

  // Add an item to a product kit
  function addItemTodelivery() {
    var item = $("#ac_item_id").val();

   if(item != "") {
      var company_id = $("#delivery_company_id").val();
      var item_id = $("#ac_item_id").val();
          
      var quantity = $("#ac_item_quantity").val();
      var price    = $("#ac_item_price").val();    
      var discount = $("#ac_item_discount").val();
      var unidad   = $("#ac_item_unidad").val();
      var peso     = $("#ac_item_peso").val();

      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Please enter a valid quantity");
      } else if(price == "" || !isNumeric(price)) {
        alert("Please enter a valid price");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Please enter a valid discount");
      } else if(peso == "" || !isNumeric(peso)) {
        alert("Please enter a valid discount");
      } else {


    var item_line = item_id + "|BRK|" + quantity + "|BRK|" + unidad+"|BRK|" + peso+"|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);

        listItemsdelivery();
        

        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        $("#ac_item2").val("");
        $("#ac_item_peso").val("0");
        updateItemdelivery();
        
      }
    } else {
      alert("Por favor primero ingrese un servicio .");
    }
  }

  // List items in a kit
  function listItemsdelivery() {
    var items = $("#items").val();
    var company_id = $("#delivery_company_id").val();
    
    $.get('/deliveries/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

  // Add an item to a product kit
  function addItemTodelivery2() {
    var item = $("#ac_item3").val();
    
   if(item != "") {
      var company_id = $("#factura_company_id").val();
      var item_id = $("#ac_item_guia").val();        
      var items_arr = $("#items2").val().split(",");
      var item_line = item_id + "|BRK|" ;
        
        $("#items2").val($("#items2").val() + "," + item_line );

        listItemsdelivery2();
        
        $("#ac_item_guia").val("");
        $("#ac_item3").val("");      
      
    } else {
      alert("Please find a guia  to add first.");
    }
  }


  function listItemsdelivery2() {
    var items2 = $("#items2").val();
    var company_id = $("#factura_company_id").val();
    
    $.get('/facturas/list_items2/' + company_id, {
      items2: items2
    },
    function(data) {
      $("#list_items2").html(data);
      documentReady();
    });
  }



  // Add an item to orden de servicio 
  function addItemToOrden1() {
    var item = $("#ac_item3").val();
    
   if(item != "") {
      var company_id = $("#purchase_company_id").val();
      var item_id = $("#ac_item_os").val();        
      var items_arr = $("#items2").val().split(",");
      var item_line = item_id + "|BRK|" ;
        
        $("#items2").val($("#items2").val() + "," + item_line );

        listItemsOrden1();
        
        $("#ac_item_os").val("");
        $("#ac_item3").val("");      
      
    } else {
      alert("Por favor añadir Orden ");
    }
  }

  function listItemsOrden1() {
    var items2 = $("#items2").val();
    var company_id = $("#factura_company_id").val();
    
    $.get('/facturas/list_items2/' + company_id, {
      items2: items2
    },
    function(data) {
      $("#list_items2").html(data);
      documentReady();
    });
  }
  // Removes an item from an invoice
  function removeItemFromOrden1(id) {
    var items = $("#items2").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items2").val(items_final.join(","));
    listItemsOrden1();
  }

  // Removes an item from a kit
  function removeItemFromKit(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(items_arr[i] != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsKit();
  }

  // Removes an item from an invoice
  function removeItemFromInvoice(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsInvoice();
  }
  // Removes an item from an invoice
  function removeItemFromInvoice2(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsInvoice2();
  }
  // Removes an item from an invoice
  function removeItemFromdelivery(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsdelivery();
  }
  // Removes an item from an invoice
  function removeItemFromdelivery2(id) {
    var items = $("#items2").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items2").val(items_final.join(","));
    listItemsdelivery2();
  }

  // Removes an item from an invoice
  function removeItemFromPurchaseorder(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemspurchaseorder();
  }
  // Removes an item from an purchase
  function removeItemFromPurchase(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsPurchase();
  }

  // Shortcut to create new customer form
  function createCustomerInvoice() {
    var company_id = $("#invoice_company_id").val();
    
    $.get('/customers/new/' + company_id + '?ajax=1', {
    },
    function(data) {
      displayRemote(data);
      showRemote();
      
      $("#new_customer").bind("submit", function() {
        event.preventDefault();
        doCreateCustomerInvoice();
      });
    });
  }

  // Create new customer in the invoice via ajax
  function doCreateCustomerInvoice() {
    var company_id = $("#invoice_company_id").val();
    var name = $("#customer_name").val();
    var email = $("#customer_email").val();
    var account = $("#customer_account").val();
    var phone1 = $("#customer_phone1").val();
    var phone2 = $("#customer_phone2").val();
    var address1 = $("#customer_address1").val();
    var address2 = $("#customer_address2").val();
    var city = $("#customer_city").val();
    var state = $("#customer_state").val();
    var zip = $("#customer_zip").val();
    var country = $("#customer_country").val();
    var comments = $("#customer_comments").val();
    
    if($("#customer_taxable").attr("checked")) {
      var taxable = 1;
    } else {
      var taxable = 0;
    }
    
    if(name != "") {
      $.post('/customers/create_ajax/' + company_id, {
        name: name,
        email: email,
        account: account,
        phone1: phone1,
        phone2: phone2,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zip: zip,
        country: country,
        comments: comments,
        taxable: taxable
      },
      function(data) {
        if(data == "error_empty") {
          alert("Please enter a customer name");
        } else if(data == "error") {
          alert("Something went wrong when saving the customer, please try again");
        } else {
          var data_arr = data.split("|BRK|");
          
          $("#ac_customer").val(data_arr[1]);
          $("#ac_customer_id").val(data_arr[0]);
          $("#selected_customer").html(data_arr[1]);
          
          hideRemote();
          alert("The customer has been created");
        }
      });
    } else {
      alert("Please enter a customer name.");
    }
  }

  // Add product kit to invoice
  function addKitToInvoice() {
    var kit = $("#ac_kit").val();
    
    if(kit != "") {
      var company_id = $("#invoice_company_id").val();
      var kit_id = $("#ac_kit_id").val();
      var discount = $("#ac_kit_discount").val();
      
      var items_arr = $("#items").val().split(",");
      
      if(discount == "" || !isNumeric(discount)) {
        alert("Please enter a valid discount");
      } else {
        $.post('/invoice/add_kit/' + company_id, {
            kit_id: kit_id,
            items: $("#items").val(),
            discount: discount
          },
          function(data) {
            if(data == "no_kit") {
              alert("We couldn't find the product kit you were looking for.");
            } else {
              $("#items").val($("#items").val() + "," + data);
              listItemsInvoice();
            }

            $("#ac_kit_id").val("");
            $("#ac_kit").val("");
          }
        );
      }
    } else {
      alert("Please find a product to add first.");
    }
  }



  // Add an item to a product kit
  function addItemToserviceorder() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#serviceorder_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var discount = $("#ac_item_discount").val();    
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese una cantidad validad");
      } else if(price == "" || !isNumeric(price)) {
        alert("Por favor ingrese un precio valido");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Por favor ingrese un descuento valido");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemsserviceorder();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        updateItemTotal4();
      }
    } else {
      alert("Por favor ingrese un servicio primero.");    
    }
  }

  // List items in a kit
  function listItemsserviceorder() {
    var items = $("#items").val();
    var company_id = $("#serviceorder_company_id").val();
    
    $.get('/serviceorders/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  // Update price total for invoice
  function updateItemTotal4() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {
      var total = quantity * price;
      total -= total * (discount / 100);

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }

  // Removes an item from an invoice
  function removeItemFromserviceorder(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsserviceorder();
  }



  // Add an item to a purchase order
          
  function addItemTopurchaseorder() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#purchaseorder_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var discount = $("#ac_item_discount").val();    
      var items_arr = $("#items").val().split(",");
        
      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese una cantidad validad");
      } else if(price == "" || !isNumeric(price)) {
        alert("Por favor ingrese un precio valido");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Por favor ingrese un descuento valido");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemspurchaseorder();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        updateItemTotal5();
      }
    } else {
      alert("Por favor ingrese un servicio primero.");
    }
  }

  function addItemToPurchase() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#purchase_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var discount = $("#ac_item_discount").val();    
      var items_arr = $("#items").val().split(",");
        
      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese una cantidad validad");
      } else if(price == "" || !isNumeric(price)) {
        alert("Por favor ingrese un precio valido");
      } else if(discount == "" || !isNumeric(discount)) {
        alert("Por favor ingrese un descuento valido");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price + "|BRK|" + discount;
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemsPurchase();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_discount").val("0");
        updateItemTotal5();
      }
    } else {
      alert("Por favor ingrese un servicio primero.");
    }
  }

  // List items in a kit
  function listItemsPurchase() {
    var items = $("#items").val();
    var company_id = $("#purchase_company_id").val();
    
    $.get('/purchases/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  // List items in a kit
  function listItemspurchaseorder() {
    var items = $("#items").val();
    var company_id = $("#purchaseorder_company_id").val();
    
    $.get('/purchaseorders/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  // Update price total for invoice
  function updateItemTotal5() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {

      var total = quantity * price;
      total -= total * (discount / 100);

      $("#ac_item_total").html( total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }


  // Add an item to a product kit
  function addItemToMovement() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#movement_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor una cantidad ");
      } else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|";
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemsMovement();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        
        updateItemTotalMov();
      }
    } else {
      alert("Please find a product to add first.");
    }
  }

  // List items in a kit
  function listItemsMovement() {
    var items = $("#items").val();
    var company_id = $("#movement_company_id").val();
    
    $.get('/movements/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

  // Update price total for invoice
  function updateItemTotalMov() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    var discount = $("#ac_item_discount").val();
    
    if(isNumeric(quantity) && isNumeric(price) && isNumeric(discount)) {
      var total = quantity * price;
      total -= total * (discount / 100);

      $("#ac_item_total").html("$" + total);
    } else {
      $("#ac_item_total").html("$0.00");
    }
  }
  // Removes an item from an invoice
  function removeItemFromMovement(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsMovement();
  }

  // Add an item to a 
  function addItemToSupplierPayment() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#supplier_payment_company_id").val();

      var importe_cheque = $("#supplier_payment_total").val();
      var item_total = 0
      var item_id = $("#ac_item_id").val();      
      var price = $("#ac_item_total").val();   

      var items_arr = $("#items").val().split(",");

      if (price == "" || !isNumeric(price)) {
        alert("Por favor ingrese un precio valido  ");
      } 
      else if (importe_cheque == "" || !isNumeric(importe_cheque)) {
        alert("Por favor ingrese importe valido  ");
      }
      else {
        var item_line = item_id + "|BRK|" + price + "|BRK|";
        
        $("#items").val($("#items").val() + "," + item_line);
        
        listItemsSupplierPayment();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_total").val("");
    
        updateItemTotal6();
      }
    } else {
      alert("Por favor ingrese un documento.");
    }
  }


  // Update price total for invoice
  function updateItemTotal6() {
    
    var price = $("#ac_item_total").val();

    if( isNumeric(price)) {
      var total =  price *1;
      
      $("#ac_item_total").html(total);
      
    } else {
      
      $("#ac_item_total").html("0.00");
    }

  }


  // List items in a kit
  function listItemsSupplierPayment() {
    var items = $("#items").val();
    var company_id = $("#supplier_payment_company_id").val();
    
    $.get('/supplier_payments/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  function removeItemFromSupplierPayment(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    

    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsSupplierPayment();
  }

// agregar item guias  
  function addItemToGuias() {

    
    var item = $("#ac_item").val();
    var company_id = $("#delivery_company_id").val();

    if(item != "") {
      var company_id = $("#delivery_company_id").val();
      var item_guia = $("#ac_item_guia").val();      
      var items_arr = $("#items").val().split(",");

      if (item_guia == "" ) {
        alert("Por favor ingrese una documento valido  ");
      }     
      else {
        var item_line = item_guia + "|BRK|";        
        $("#items").val($("#items").val() + "," + item_line);        
        listItemsGuias();        
        $("#ac_item_guia").val("");
        $("#ac_item").val("");          
      }
    } else {
      alert("Por favor ingrese un documento.");
    }
  }

  // List items in a kit
  function listItemsGuias() {
    var items = $("#items").val();
    
    $.get('/deliveries/list_items2/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items2").html(data);
      documentReady();
    });
  }


  function removeItemFromGuias(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    

    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsGuias();
  }

  //............................................................................
  // agrega items customer payments
  //............................................................................

  function addItemToCustomerPayment() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#customer_payment_company_id").val();

      var importe_cheque = $("#customer_payment_total").val();
      var item_total = 0
      var item_id = $("#ac_item_id").val();      
      var factory = $("#ac_item_factory").val();      
      var compen = $("#ac_item_compen").val();      
      var ajuste = $("#ac_item_ajuste").val(); 

      var price = $("#ac_item_total").val();   
      var items_arr = $("#items").val().split(",");

      if(factory == "" || !isNumeric(factory)) {
        alert("Por favor ingrese una cantidad validad");
      }
      else if  (compen == "" || !isNumeric(compen)) {
        alert("Por favor ingrese una compensacion valida  ");
      }      
      else if  (price == "" || !isNumeric(price)) {
        alert("Por favor ingrese un precio valido  ");
      } 
      else if  (ajuste == "" || !isNumeric(ajuste)) {
        alert("Por favor ingrese un importe de ajuste valido  ");
      }       
      else {
        var item_line = item_id + "|BRK|" + compen  + "|BRK|" + ajuste + "|BRK|"+ factory + "|BRK|"+ price + "|BRK|";
        
        $("#items").val($("#items").val() + "," + item_line);
        
        listItemsCustomerPayment();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_total").val("");
        $("#ac_item_factory").val("");
        $("#ac_item_ajuste").val("");
        $("#ac_item_compen").val("");

        updateItemTotalCP();
      }
    } else {
      alert("Por favor ingrese un documento.");
    }
  }
//............................................................................
  // agrega items customer payments
  //............................................................................

  function addItemToCustomerPayment2() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#customer_payment_company_id").val();

      var importe_cheque = $("#customer_payment_total").val();
      
      var item_total = 0;
      var item_id = "";
      var fecha1 = $("#ac_fecha1").val();      
      var factory = 0 ;
      var compen  = 0 ;
      var ajuste  = 0 ;

      var items_arr = $("#items").val().split(",");

      if(fecha1 == "") {
        alert("Por favor ingrese una fecha");
        }       
      else {
        
        $result = pg_query("SELECT id,balance FROM facturas where balance > 0 and fecha = ? ", [Date.parse(fecha1)]);
        
    
      if (!$result) {
        
          
        }

        
        while($myrow = pg_fetch_assoc($result)) {

            var item_line = $myrow[id] + "|BRK|" + compen  + "|BRK|" + ajuste + "|BRK|"+ factory + "|BRK|"+ $myrow[balance]  + "|BRK|";
            $("#items").val($("#items").val() + "," + item_line);
        
        }
        
        
        
        
        listItemsCustomerPayment();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_total").val("");
        $("#ac_item_factory").val("");
        $("#ac_item_ajuste").val("");
        $("#ac_item_compen").val("");

        updateItemTotalCP();
      }
    } else {
      alert("Por favor ingrese un documento.");
    }
  }


  // Update price total for invoice
  function updateItemTotalCP() {
    var saldooriginal = $("#ac_item_total").val();

    var price     = $("#ac_item_total").val();

    var factory  = $("#ac_item_factory").val();

    var ajuste   = $("#ac_item_ajuste").val();

    var compen   = $("#ac_item_compen").val();

    $("#ac_item_total2").html(saldooriginal);

    if( isNumeric(price) && isNumeric(factory) && isNumeric(ajuste) && isNumeric(saldooriginal) && isNumeric(compen))  {
      
      var total = price + factory + ajuste ;

      
    } else {

    $("#ac_item_total2").html(saldooriginal);
            
    }

  }

  // List items in a kit
  function listItemsCustomerPayment() {
    var items = $("#items").val();
    var company_id = $("#customer_payment_company_id").val();
    
    $.get('/customer_payments/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  function removeItemFromCustomerPayment(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
  
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsCustomerPayment();
  }

 //............................................................................  

  // Add an item to a product kit
  function addItemToOutput() {
    var item = $("#ac_item").val();
    
    if(item != "") {
      var company_id = $("#output_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
      var price = $("#ac_item_price").val();
      var stock = $("#ac_item_stock").val();
    
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese una cantidad valida");
      }  else if( Number(quantity) > Number(stock) ) {
        alert("Por favor ingrese una cantidad igual o menor al stock ");
      }  else {
        var item_line = item_id + "|BRK|" + quantity + "|BRK|" + price ;
        
        $("#items").val($("#items").val() + "," + item_line);
        
        listItemsOutput();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        $("#ac_item_price").val("");
        $("#ac_item_stock").val("");
      
        updateItemTotalOutput();
      }
    } else {
      alert("Por favor agregue un item .");
    }
  }

  // List items in a kit
  function listItemsOutput() {
    var items = $("#items").val();
    var company_id = $("#output_company_id").val();
    
    $.get('/outputs/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

// Update price total for invoice
  function updateItemTotalOutput() {
    var quantity = $("#ac_item_quantity").val();
    var price = $("#ac_item_price").val();
    
    
    if(isNumeric(quantity) && isNumeric(price)) {
      var total = quantity * price;      

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }

// Removes an item from an invoice
  function removeItemFromOutput(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsOutput();
  }
 //............................................................................  

 //............................................................................  
  // Add an item to a product kit
  function addItemToAjust() {
    var item = $("#ac_item").val();
   
    
    if(item != "") {
      var company_id = $("#ajust_company_id").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_quantity").val();
    
    
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese una cantidad valida");
      }  else {
        var item_line = item_id + "|BRK|" + quantity ;
        
        $("#items").val($("#items").val() + "," + item_line);
        
        listItemsAjust();
        
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_quantity").val("1");
        
        updateItemTotalAjust();
      }
    } else {
      alert("Por favor agregue un item ajuste.");
    }
  }


  // List items in a kit
  function listItemsAjust() {
    var items = $("#items").val();
    var company_id = $("#ajust_company_id").val();
    
    $.get('/ajusts/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

// Update price total for invoice
  function updateItemTotalAjust() {
    var quantity = $("#ac_item_quantity").val();
    
    
    
    if(isNumeric(quantity)) {
      var total = quantity;      

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }

// Removes an item from an invoice
  function removeItemFromAjust(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsAjust();
  }
  
  // Add an item to a product
  function addItemToViatico() {
    
    var item = $("#ac_item").val();

    if(item != "") {
      var company_id = $("#viatico_company_id").val();
      var inicial = $("#viatico_inicial").val();
      var tm = $("#tm").val();
      var item_id = $("#ac_item_id").val();
      
      var quantity = $("#ac_item_total").val();
      var compro  = $("#ac_item_compro").val();
      var detalle= $("#ac_item_detalle").val();
      var fecha  = $("#ac_item_fecha").val();
      var ruc    = $("#ac_supplier_id").val();
      var gasto    = $("#gasto_id").val();
      var empleado =$("#ac_employee_id").val();
      var items_arr = $("#items").val().split(",");

      if(quantity == "" || !isNumeric(quantity)) {
        alert("Por favor ingrese un importe valido");
      } else if(fecha == "" ) {
        alert("Por favor ingrese una fecha");
      } else if(gasto == "" || !isNumeric(gasto)) {
        alert("Por favor ingrese un gasto  ");
      } else if(empleado == "" || !isNumeric(empleado)) {
        alert("Por favor ingrese un empleado ");
      } else {

      
      var item_line = item_id + "|BRK|" + quantity + "|BRK|" +detalle + "|BRK|" +tm + "|BRK|"+inicial + "|BRK|"+compro+ "|BRK|"+fecha+ "|BRK|"+ruc+ "|BRK|"+gasto+ "|BRK|"+empleado ;
      
        $("#items").val($("#items").val() + "," + item_line);
        listItemsViatico();
          $("#tm").val("");
        $("#ac_item_id").val("");
        $("#ac_item").val("");
        $("#ac_item_total").val("0.00");
        $("#ac_item_compro").val("");
        $("#ac_item_detalle").val("");
        $("#ac_item_ruc").val("");
        $("#ac_item_empleado").val("");        
        updateItemTotalViatico();
      }
    } else {
      alert("Por favor ingrese un detalle primero.");    
    }
  }

  // List items in a kit
 


  // List items in a kit
  function listItemsViatico() {
    
    var items = $("#items").val();
    var company_id = $("#viatico_company_id").val();
    
    $.get('/viaticos/list_items/' + company_id, {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }

  // Update price total for invoice
  function updateItemTotalViatico() {
    var quantity = $("#ac_item_quantity").val();
    
    if(isNumeric(quantity) ) {
      var total = quantity ;
      

      $("#ac_item_total").html(total);
    } else {
      $("#ac_item_total").html("0.00");
    }
  }

  // Removes an item from an invoice
  function removeItemFromViatico(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemsViatico();
    
  }


  
  // Add an item to a LGV.
  
  function addItemTolgv() {

    
    var item = $("#ac_item").val();
    if(item != "") {
      var company_id = $("#lgv_company_id").val();
      var stock_inicial = $("#ac_item_inicial").val();
      var peaje = $("#lgv_peaje").val();
        
      var item_id = $("#ac_item_id").val();
      var ac_item_fecha = $("#ac_item_fecha").val();
    
      var td        = $("#ac_item_td").val();
      var documento = $("#ac_item_documento").val();
      var importe   = $("#ac_item_importe").val();
      var detalle   = $("#ac_item_detalle").val();
      
      var items_arr = $("#items").val().split(",");

      if(importe == "" || !isNumeric(importe)) {
        alert("Por favor ingrese un importe valido");
      } else {
      
      var item_line = item_id + "|BRK|" +ac_item_fecha + "|BRK|" + td + "|BRK|"+documento + "|BRK|"+ importe + "|BRK|"+ peaje + "|BRK|"+ stock_inicial+ "|BRK|"+ detalle;
        
        $("#items").val($("#items").val() + "," + item_line);
        listItemslgv();
        
        $("#ac_item").val("");
        $("#ac_item_id").val("");        
        $("#ac_td").val("");
        $("#ac_documento").val("");
        $("#ac_item_total").val("0.00");
        $("#ac_item_detalle").val("");
        
      }
    } else {
      alert("Por favor ingrese un detalle primero.");    
    }
  }

  // List items in a kit
  function listItemslgv() {
    
    var items = $("#items").val();
    var company_id = $("#lgv_company_id").val();
    
    $.get('/lgvs/list_items/' + company_id ,  {
      items: items
    },
    function(data) {
      $("#list_items").html(data);
      documentReady();
    });
  }


  // Removes an item from an invoice
  function removeItemFromlgv(id) {
    var items = $("#items").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items").val(items_final.join(","));
    listItemslgv();
  }

 //............................................................................  
 
function addItemToLgv2() {
    var item = $("#ac_item_compro").val();
    
   if(item != "") {
      var company_id = $("#lgv_company_id").val();
      var item_id = $("#ac_compro_id").val();        
      var inicial = $("#ac_item_inicial").val();        
      
      var items_arr = $("#items2").val().split(",");
      
      var item_line = item_id + "|BRK|" + inicial ;
        
        $("#items2").val($("#items2").val() + "," + item_line );

        listItemsLgv2();
        
        $("#ac_item_compro").val("");
        $("#ac_item_inicial").val("");
        $("#ac_compro_id").val("");      
      
    } else {
      alert("Por favor ingreso informacion de comprobante.");
    }
  }


  function listItemsLgv2() {
    var items2 = $("#items2").val();
    var company_id = $("#lgv_company_id").val();
    
    $.get('/lgvs/list_items2/' + company_id, {
      items2: items2
    },
    function(data) {
      $("#list_items2").html(data);
      documentReady();
    });

  }

// Removes an item from an invoice
  function removeItemFromLgv2(id) {
    var items = $("#items2").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items2").val(items_final.join(","));
    listItemsLgv2();
  }

  
 //............................................................................  
// Shortcut to create new customer form
  function createSupplier() {
    var company_id = $("#viatico_company_id").val();
    
    $.get('/suppliers/new/' + company_id + '?ajax=1', {
    },
    function(data) {
      displayRemote(data);
      showRemote();
      
      $("#new_supplier").bind("submit", function() {
        event.preventDefault();
        doCreateSupplier();
      });
    });
  }

  // Create new customer in the invoice via ajax
  function doCreateSupplier() {
    var company_id = $("#viatico_company_id").val();
    var ruc = $("#supplier_ruc").val();
    var name = $("#supplier_name").val();
    var email = $("#supplier_email").val();
    var phone1 = $("#supplier_phone1").val();
    var phone2 = $("#supplier_phone2").val();
    var address1 = $("#supplier_address1").val();
    var address2 = $("#supplier_address2").val();
    var city = $("#supplier_city").val();
    var state = $("#supplier_state").val();
    var zip = $("#supplier_zip").val();
    var country = $("#supplier_country").val();
    var comments = $("#supplier_comments").val();
    
    if($("#supplier_taxable").attr("checked")) {
      var taxable = 1;
    } else {
      var taxable = 0;
    }
    
    if(name != "") {
      $.post('/suppliers/create_ajax/' + company_id, {
        name: name,
        email: email,
        phone1: phone1,
        phone2: phone2,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zip: zip,
        country: country,
        comments: comments,
        taxable: taxable
      },
      function(data) {
        if(data == "error_empty") {
          alert("Please enter a supplier name");
        } else if(data == "error") {
          alert("Ah ocurrido un error grabando el proveedor ,por favor trate otra vez ");
        } else {
          var data_arr = data.split("|BRK|");
          
          $("#ac_supplier").val(data_arr[1]);
          $("#ac_supplier_id").val(data_arr[0]);
          $("#selected_supplier").html(data_arr[1]);
          
          hideRemote();
          alert("Proveedor creado");
        }
      });
    } else {
      alert("Por favor ingrese un proveedor.");
    }
  }

  
 //............................................................................  
// Shortcut to create new customer form
  function createSupplier2() {
    
    alert("sup");
    var company_id = $("#purchaseorder_company_id").val();
    
    $.get('/suppliers/new/' + company_id + '?ajax=1', {
    },
    function(data) {
      displayRemote(data);
      showRemote();
      
      $("#new_supplier").bind("submit", function() {
        event.preventDefault();
        doCreateSupplier2();
      });
    });
  }

  // Create new customer in the invoice via ajax
  function doCreateSupplier2() {
    var company_id = $("#purchaseorder_company_id").val();
    var ruc = $("#supplier_ruc").val();
    var name = $("#supplier_name").val();
    var email = $("#supplier_email").val();
    var phone1 = $("#supplier_phone1").val();
    var phone2 = $("#supplier_phone2").val();
    var address1 = $("#supplier_address1").val();
    var address2 = $("#supplier_address2").val();
    var city = $("#supplier_city").val();
    var state = $("#supplier_state").val();
    var zip = $("#supplier_zip").val();
    var country = $("#supplier_country").val();
    var comments = $("#supplier_comments").val();
    
    if($("#supplier_taxable").attr("checked")) {
      var taxable = 1;
    } else {
      var taxable = 0;
    }
    
    if(name != "") {
      $.post('/suppliers/create_ajax/' + company_id, {
        name: name,
        email: email,
        phone1: phone1,
        phone2: phone2,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zip: zip,
        country: country,
        comments: comments,
        taxable: taxable
      },
      function(data) {
        if(data == "error_empty") {
          alert("Please enter a supplier name");
        } else if(data == "error") {
          alert("Ah ocurrido un error grabando el proveedor ,por favor trate otra vez ");
        } else {
          var data_arr = data.split("|BRK|");
          
          $("#ac_supplier").val(data_arr[1]);
          $("#ac_supplier_id").val(data_arr[0]);
          $("#selected_supplier").html(data_arr[1]);
          
          hideRemote();
          alert("Proveedor creado");
        }
      });
    } else {
      alert("Por favor ingrese un proveedor.");
    }
  }


//marca

function createMarca() {
    alert("aa");
    var company_id = $("#product_company_id").val();
    
    $.get('/marcas/new/' + company_id + '?ajax=1', {
    },
    function(data) {
      displayRemote(data);
      showRemote();
      
      $("#new_marca").bind("submit", function() {
        event.preventDefault();
        doCreateMarca();
      });
    });
  }
  
 // Create new marca in the invoice via ajax
  function doCreateMarca() {
    var company_id = $("#product_company_id").val();
    var name = $("#marca_descrip").val();
  
    if(name != "") {
      $.post('/marcas/create_ajax/' + company_id, {
        descrip: name
      },
      function(data) {
        if(data == "error_empty") {
          alert("Por favor ingreso una descripcion de marca");
        } else if(data == "error") {
          alert("Ah ocurrido un error grabando la marca,por favor trate otra vez ;-)");
        } else {
          var data_arr = data.split("|BRK|");
          
          hideRemote();
          alert("marca creado");
        }
      });
    } else {
      alert("Por favor ingrese una marca.");
    }
  }

  // On ready
  $(document).ready(function() {
    documentReady();
    
    $("#loading")
      .hide()
      .ajaxStart(function() {
        showLoading();
      })
      .ajaxStop(function() {
        hideLoading();
      })
    ;
  });




