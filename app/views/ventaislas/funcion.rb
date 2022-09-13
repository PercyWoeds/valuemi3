
function myFunction() {


  var x = document.getElementsByTagName("input");

  console.log("x: " + x);
  console.log("Number of inputs: " + x.length);

  var arrayOfInputNames = [];
  var campo_gln ;
  var campo_dif ;


      for (var i = 0; i < x.length; i++) {
      //for(key in x) {
        console.log("i: " + i);
        console.log("value: " + x[i].name);

        arrayOfInputNames.push(x[i].name );

       // var contacto = $('input[name="contacto"]').val();

      }

  //document.writeln((i+1) + ": " + arrayOfInputNames[i]);
   
   var cadena = "" ;
   var diferencia = 0; 

  fLen = arrayOfInputNames.length;

    for (i = 0; i < fLen; i++) {

       cadena = arrayOfInputNames[i] ;

      if (cadena.substring(0,6) == "SALIDA_" ){

              campo_ent = "ENTRADA_" + cadena.substring(7,12) ;
              campo_sal = "SALIDA_"  + cadena.substring(7,12) ;
              campo_gln = "GLNS_"    + cadena.substring(7,12) ;
              campo_pre = "PRECIO_"  + cadena.substring(7,12) ;

              campo_sub = "SUBTOTAL_"  + cadena.substring(7,12) ;
             
              diferencia = ($("input[name="+campo_sal+"]").val() - $("input[name="+campo_ent+"]").val());

              subtotal = diferencia  *  $("input[name="+campo_pre +"]").val() ;

              //alert(diferencia);
              document.getElementById(campo_gln).innerHTML = Number((diferencia).toFixed(2));;
              document.getElementById(campo_sub).innerHTML = Number((subtotal).toFixed(2));;

            }
        else {

        
        }

      }

}
