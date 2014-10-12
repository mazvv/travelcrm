<table width="100%" class="grid-details">
    <tr>
        <td>
            % if item.descr:
                ${h.tags.literal(item.descr)}
            % else:
                ${_(u'no description')}
            % endif
        </td>
    </tr>
</table>
