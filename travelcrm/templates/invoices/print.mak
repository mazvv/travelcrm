<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
    
    <title>${_(u'Invoice')} #${invoice.id}</title>
    <style>
		* { margin: 0; padding: 0; }
		#page-wrap { width: 800px; margin: 0 auto; }
		
		table { border-collapse: collapse; }
		table td, table th { border: 1px solid black; padding: 5px; }
		
		#header { height: 15px; width: 100%; margin: 20px 0; background: #222; text-align: center; color: white; font: bold 15px Helvetica, Sans-Serif; text-decoration: uppercase; letter-spacing: 20px; padding: 8px 0px; }
		#identity { margin-top: 40px; }
		#address { width: 250px; height: 150px; float: left; }
		#customer { overflow: hidden; }
		
		#logo { text-align: right; float: right; position: relative; margin-top: 25px; border: 1px solid #fff; max-width: 540px; max-height: 100px; overflow: hidden; }
		#logo:hover, #logo.edit { border: 1px solid #000; margin-top: 0px; max-height: 125px; }
		#logoctr { display: none; }
		#logo:hover #logoctr, #logo.edit #logoctr { display: block; text-align: right; line-height: 25px; background: #eee; padding: 0 5px; }
		#logohelp { text-align: left; display: none; font-style: italic; padding: 10px 5px;}
		#logohelp input { margin-bottom: 5px; }
		.edit #logohelp { display: block; }
		.edit #save-logo, .edit #cancel-logo { display: inline; }
		.edit #image, #save-logo, #cancel-logo, .edit #change-logo, .edit #delete-logo { display: none; }
		#customer-title { font-size: 20px; font-weight: bold; float: left; }
		
		#meta { margin-top: 1px; width: 300px; float: right; }
		#meta td { text-align: right;  }
		#meta td.meta-head { text-align: left; background: #eee; }
		#meta td span { width: 100%; height: 20px; text-align: right; }
		
		#items { clear: both; width: 100%; margin: 30px 0 0 0; border: 1px solid black; }
		#items th { background: #eee; }
		#items span { width: 80px; height: 50px; }
		#items tr.item-row td { border: 0; vertical-align: top; }
		#items td.description { width: 300px; }
		#items td.item-name { width: 175px; }
		#items td.description span, #items td.item-name span { width: 100%; }
		#items td.total-line { border-right: 0; text-align: right; }
		#items td.total-value { border-left: 0; padding: 10px; }
		#items td.total-value span { height: 20px; background: none; }
		#items td.balance { background: #eee; }
		#items td.blank { border: 0; }
		#items td span.qty { text-align: center; }
		
		#terms { text-align: center; margin: 20px 0 0 0; }
		#terms h5 { text-transform: uppercase; font: 13px Helvetica, Sans-Serif; letter-spacing: 10px; border-bottom: 1px solid black; padding: 0 0 8px 0; margin: 0 0 8px 0; }
		#terms span { width: 100%; text-align: center;}
		
		span:hover, span:focus, #items td.total-value span:hover, #items td.total-value span:focus, .delete:hover { background-color:#EEFF88; }
		
		.delete-wpr { position: relative; }
		.delete { display: block; color: #000; text-decoration: none; position: absolute; background: #EEEEEE; font-weight: bold; padding: 0px 3px; border: 1px solid; top: -6px; left: -22px; font-family: Verdana; font-size: 12px; }
    </style>    

</head>

<body>

    <div id="page-wrap">

        <span id="header">${_(u'INVOICE')}</span>
        
        <div id="identity">
        
            <span id="address">
123 Appleseed Street
Appleville, WI 53719

Phone: (555) 555-5555</span>

            <div id="logo">${h.common.get_company_name()}</div>
        
        </div>
        
        <div style="clear:both"></div>
        
        <div id="customer">

            <table id="meta">
                <tr>
                    <td class="meta-head">${_(u'Invoice #')}</td>
                    <td><span>${invoice.id}</span></td>
                </tr>
                <tr>

                    <td class="meta-head">${_(u'Date')}</td>
                    <td><span id="date">${h.common.format_date(invoice.date)}</span></td>
                </tr>
                <tr>
                    <td class="meta-head">${_(u'Amount Due')}</td>
                    <td><div class="due">${h.common.format_decimal(factory.get_sum_by_invoice_id(invoice.id))} ${invoice.account.currency.iso_code}</div></td>
                </tr>

            </table>
        
        </div>
        
        <table id="items">
        
          <tr>
              <th width="60%">${_(u'Description')}</th>
              <th>${_(u'Unit Cost')}</th>
              <th>${_(u'Quantity')}</th>
              <th>${_(u'Price')}</th>
          </tr>
          
          % for item in factory.services_info(resource_id, invoice.account.currency_id):
          <tr class="item-row">
              <td class="description">
                  <div class="delete-wpr">
                      <span>${item.name}</span>
                  </div>
              </td>
              <td><span class="cost">${h.common.format_decimal(item.unit_price)} ${invoice.account.currency.iso_code}</span></td>
              <td><span class="qty">${item.cnt}</span></td>
              <td><span class="price">${h.common.format_decimal(item.price)} ${invoice.account.currency.iso_code}</span></td>
          </tr>
          % endfor

          <tr>

              <td colspan="2" class="blank"> </td>
              <td class="total-line">${_(u'Total')}</td>
              <td class="total-value"><div id="total">${h.common.format_decimal(factory.get_sum_by_invoice_id(invoice.id))} ${invoice.account.currency.iso_code}</div></td>
          </tr>
          <tr>
              <td colspan="2" class="blank"> </td>
              <td class="total-line">${_(u'Amount Paid')}</td>

              <td class="total-value"><span id="paid">${h.common.format_decimal(payment_sum)} ${invoice.account.currency.iso_code}</span></td>
          </tr>
          <tr>
              <td colspan="2" class="blank"> </td>
              <td class="total-line balance">${_(u'Balance Due')}</td>
              <td class="total-value balance"><div class="due">${h.common.format_decimal(factory.get_sum_by_invoice_id(invoice.id) - payment_sum)} ${invoice.account.currency.iso_code}</div></td>
          </tr>
        
        </table>
        
        <div id="terms">
          <h5>Terms</h5>
          <span>NET 30 Days. Finance Charge of 1.5% will be made on unpaid balances after 30 days.</span>
        </div>
    
    </div>
    
</body>

</html>
