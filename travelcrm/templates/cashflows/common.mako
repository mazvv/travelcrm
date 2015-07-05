<%def name="cashflow_list_details(cashflows)">
    <div class="dp100">
        <div class="b dp10">${_(u'date')}</div>
        <div class="b dp30">${_(u'from')}</div>
        <div class="b dp30">${_(u'to')}</div>
        <div class="b dp15">${_(u'sum')}</div>
        <div class="b dp15">${_(u'vat')}</div>
    </div>
    % for cashflow in cashflows:
        <div class="dp100">
            <div class="dp10">
                ${h.common.format_date(cashflow.date)}
            </div>
            <div class="dp30">
                % if cashflow.subaccount_from:
                    ${cashflow.subaccount_from.name}
                % else:
                    &nbsp;
                % endif
            </div>
            <div class="dp30">
                % if cashflow.subaccount_to:
                    ${cashflow.subaccount_to.name}
                % else:
                    &nbsp;
                % endif
            </div>
            <div class="dp15">
                ${h.common.format_decimal(cashflow.sum)}
            </div>
            <div class="dp15">
                % if cashflow.vat:
                    ${h.common.format_decimal(cashflow.vat)}
                % else:
                    &nbsp;
                % endif
            </div>
        </div>
    % endfor
</%def>
