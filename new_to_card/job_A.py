
from rialto.jobs.decorators import job

@job
def job_A() -> None:
    """
    Simple Test Job to Print a Message

    :return: None
    """

    print("This is a test job. Hi.")