<%namespace file="../contacts/common.mako" import="contact_list_details"/>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>A simple, clean, and responsive HTML invoice template</title>
<style>
body {
	font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
	text-align: center;
	color: #777;
}

body h1 {
	font-weight: 300;
	margin-bottom: 0px;
	padding-bottom: 0px;
	color: #000;
}

body h3 {
	font-weight: 300;
	margin-top: 10px;
	margin-bottom: 20px;
	font-style: italic;
	color: #555;
}

body a {
	color: #06F;
}

.invoice-box {
	max-width: 800px;
	margin: auto;
	padding: 30px;
	border: 1px solid #eee;
	box-shadow: 0 0 10px rgba(0, 0, 0, .15);
	font-size: 16px;
	line-height: 24px;
	font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
	color: #555;
}

.invoice-box table {
	width: 100%;
	line-height: inherit;
	text-align: left;
}

.invoice-box table td {
	padding: 5px;
	vertical-align: top;
}

.invoice-box table tr td:nth-child(2) {
	text-align: right;
}

.invoice-box table tr.top table td {
	padding-bottom: 20px;
}

.invoice-box table tr.top table td.title {
	font-size: 45px;
	line-height: 45px;
	color: #333;
}

.invoice-box table tr.information table td {
	padding-bottom: 40px;
}

.invoice-box table tr.heading td {
	background: #eee;
	border-bottom: 1px solid #ddd;
	font-weight: bold;
}

.invoice-box table tr.details td {
	padding-bottom: 20px;
}

.invoice-box table tr.item td {
	border-bottom: 1px solid #eee;
}

.invoice-box table tr.item.last td {
	border-bottom: none;
}

.invoice-box table tr.total td:nth-child(2) {
	border-top: 2px solid #eee;
	font-weight: bold;
}

@media only screen and (max-width: 600px) {
	.invoice-box table tr.top table td {
		width: 100%;
		display: block;
		text-align: center;
	}
	.invoice-box table tr.information table td {
		width: 100%;
		display: block;
		text-align: center;
	}
}
</style>
</head>
<body>
    <div class="invoice-box">
        <table cellpadding="0" cellspacing="0">
            <tr class="top">
                <td colspan="2">
                    <table>
                        <tr>
                            <td class="title">
                            </td>
                            <td>${_(u'Invoice')} #: ${invoice.id}<br> ${_(u'Created')}:
                                ${h.common.format_date(invoice.date)}<br> ${_(u'Due')}: ${h.common.format_date(invoice.active_until)}
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="information">
                <td colspan="2">
                    <table>
                        <tr>
                            <td>${h.common.get_company_name()}<br> 12345
                                Sunny Road<br> Sunnyville, TX 12345
                            </td>
                            <td>${invoice.order.customer.name}<br>
                                ${contact_list_details(invoice.order.customer.contacts)}
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="heading">
                <td>${_(u'Item')}</td>
                <td>${_(u'Price')}, ${invoice.account.currency.iso_code}</td>
            </tr>
            % for item in invoice.invoices_items:
                <tr class="item">
                    <td>${item.order_item.service.display_text}</td>
                    <td>${h.common.format_decimal(item.final_price)}</td>
                </tr>
            % endfor
            <tr class="total">
                <td></td>
                <td>
                    <div>${_(u'Vat')}: ${h.common.format_decimal(invoice.vat)}</div>
                    <div>${_(u'Total')}: ${h.common.format_decimal(invoice.final_price)}</div>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
