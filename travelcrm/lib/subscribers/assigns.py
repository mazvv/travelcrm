#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.assigns import (
    AssignRun,
) 
from ..scheduler.assigns import (
    schedule_assign,
)


@subscriber(AssignRun)
def assign_run(event):
    schedule_assign(event.from_employee.id, event.to_employee.id)
