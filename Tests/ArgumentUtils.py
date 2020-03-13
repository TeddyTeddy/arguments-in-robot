from robot.api.deco import keyword
from robot.api import logger


@keyword('My "Run Process"')
def my_run_process(command, *arguments, **configuration):
    logger.debug(f'command: {command}')
    logger.debug(f'arguments: {arguments}')
    logger.debug(f'configuration: {configuration}')

