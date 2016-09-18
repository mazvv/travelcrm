# -*coding: utf-8-*-

import logging
import transaction
from functools import wraps

from ...models import DBSession
from ...lib.utils.sql_utils import get_current_schema, set_search_path
from ...lib.utils.common_utils import gen_id  
from ...lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


def gen_task_id(suffix=None):
    current_schema = get_current_schema()
    return (
        gen_id(prefix=current_schema + '_', limit=12)
        if not suffix else
        current_schema + '_' + suffix
    )


def get_schema_from_job_id(job_id):
    segments = job_id.split('_')
    return '_'.join(segments[:-1])
    

def bucket(limit):
    def wrapper(func):
        @wraps(func)
        def _wrapper(*args, **kwargs):
            offset = getattr(func, '_offset', 0)
            gen = func(*args, **kwargs)
            try:
                query = gen.next()
            except StopIteration:
                raise RuntimeError(_(u'Generator need'))
            
            query = query.limit(limit).offset(offset)
            log.info('Bucket limit: %s, offset: %s' % (limit, offset))
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
        log.info('Switch to schema: %s' % get_schema_from_job_id(job_id))
        set_search_path(get_schema_from_job_id(job_id))
        result = task(*args, **kwargs)
        set_search_path(current_schema)
        log.info('Return to schema: %s' % get_schema_from_job_id(job_id))
        return result
    return _task


def transactional(task):
    @wraps(task)
    def _task(*args, **kwargs):
        with transaction.manager:
            task(*args, **kwargs)
    return _task


def after_commit(f):
    def _wrapper_f(success, *args, **kwargs):
        return f(*args, **kwargs)
    def _wrapper(*args, **kwargs):
        t = transaction.get()
        t.addAfterCommitHook(_wrapper_f, args, kwargs)
    return _wrapper
