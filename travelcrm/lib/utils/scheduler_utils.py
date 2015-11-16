# -*coding: utf-8-*-

import logging
from functools import wraps

from ...lib.utils.sql_utils import get_current_schema, set_search_path
from ...lib.utils.common_utils import gen_id  
from ...lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


def gen_task_id():
    current_schema = get_current_schema()
    return gen_id(prefix=current_schema + '_', limit=12)


def get_schema_from_job_id(job_id):
    return job_id.split('_')[0]
    


def bucket(limit):
    def wrapper(func):
        def _wrapper(*args, **kwargs):
            offset = getattr(func, '_offset', 0)
            gen = func(*args, **kwargs)
            try:
                query = gen.next()
            except StopIteration:
                raise RuntimeError(_(u'Generator need'))
            
            query = query.limit(limit).offset(offset)
            try:
                if query.count() == 0:
                    raise RuntimeError()
                gen.send(query)
            except StopIteration:
                setattr(func, '_offset', offset + limit)
                _wrapper(*args, **kwargs)
            except RuntimeError:
                log.info(_(u'Generator exhausted'))
                delattr(func, '_offset')
            gen.close()
        return _wrapper
    return wrapper


def scopped_task(task):
    task.scopped = True
    @wraps(task)
    def _task(*args, **kwargs):
        job_id = kwargs.pop('_job_id')
        if not job_id:
            raise ValueError(u'Job Id is not defined')
        current_schema = get_current_schema()
        set_search_path(get_schema_from_job_id(job_id))
        result = task(*args, **kwargs)
        set_search_path(current_schema)
        return result
    return _task
