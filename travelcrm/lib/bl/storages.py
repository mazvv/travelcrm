# -*coding: utf-8-*-

import sys

from bitmath import Byte, MiB

from ...lib.utils.common_utils import get_storage_max_size

CHUNK_SIZE = 1024


def is_allowed_file_size(f):
    """ check if given file size is less or equal as max allowed in config
    """
    max_size = get_storage_max_size()
    return Byte(get_file_size(f)) <= MiB(float(max_size))
        

def get_file_size(f):
    """ get file size in Bytes
    """
    size = 0
    while True:
        chunk = f.read(CHUNK_SIZE)
        if not chunk:
            break
        size += sys.getsizeof(chunk)
    return size
    