import asyncio
from custom_executor.errors import ProcessCancelError
import os
import signal


class Interruptable:
    def __init__(self, cmd):
        self._cmd = cmd
        self._pgids = []
        self.out_collect = []
        self.err_collect = []
        self.state = []

    def out_f(self, x: bytes) -> bool:
        return True

    def err_f(self, x: bytes) -> bool:
        return True

    @staticmethod
    async def _process_stream(stream, output_func):
        while True:
            line = await stream.readline()
            if not line:
                break
            if not output_func(line):
                raise ProcessCancelError

    async def subprocess(self, raise_on_term=False,term_on_term=True):
        process = await asyncio.create_subprocess_shell(
            self._cmd,
            executable='/bin/bash',
            shell=True,
            stdin=asyncio.subprocess.PIPE,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
            preexec_fn=os.setsid
        )
        pid = process.pid
        try:
            self._pgids.append(pid)
        except Exception as e:
            print(pid)
            print(e)
        tasks = [
            asyncio.create_task(self._process_stream(process.stdout, self.out_f)),
            asyncio.create_task(self._process_stream(process.stderr, self.err_f))
        ]
        try:
            await asyncio.gather(
                *tasks
            )
        except ProcessCancelError:
            for t in tasks:
                t.cancel()
                if term_on_term:
                    process.terminate()
                if raise_on_term:
                    raise ProcessCancelError

        return await process.wait()


    def execute(self,raise_on_term=False,term_on_term=True):
        asyncio.run(
            self.subprocess(raise_on_term,term_on_term)
        )

    def pgkill(self):

        try:
            os.killpg(self._pgids[0], signal.SIGINT)
        except ProcessLookupError as e:
            print(e)




