
from custom_executor.interruptible_cls import Interruptable
import copy
from typing import List
import asyncio
import time
from custom_executor.errors import ProcessCancelError

async def run_all_gather(executor_list: List[Interruptable],term):
    tasks = [asyncio.create_task(e.subprocess(term)) for e in executor_list]
    try:
        await asyncio.gather(*tasks)
    except ProcessCancelError:
        for p in tasks:
            p.cancel()
            return False
    return True

def run_until_end(subprocess_list: List[Interruptable]):
    asyncio.run(run_all_gather(subprocess_list, False))


def run_until_term(subprocess_list: List[Interruptable]):
    asyncio.run(run_all_gather(subprocess_list, True))


async def run_with_rety_a(subprocess_orig: Interruptable, retires: int, retry_wait: int):
    tries = 0
    while(True):
        tries = tries+1
        if tries <= retires:
            try:
                await subprocess_orig.subprocess(True)
                return True
            except ProcessCancelError as e:
                subprocess_orig.out_collect = []
                time.sleep(retry_wait)
                continue
        return False


def run_with_rety(subprocess_orig: Interruptable, retires: int, retry_wait: int):
    return asyncio.run(
        run_with_rety_a(subprocess_orig, retires, retry_wait)
    )

