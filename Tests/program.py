import sys
from robot.api import logger

if __name__ == '__main__':  # if invoked via Run Process keyword
    logger.info(f'Program.py got called with sys.argv: {str(sys.argv[1:])}')
    print(f'Program.py got called with sys.argv: {str(sys.argv[1:])}')


