from monailabel.interface import ActiveLearning


class MyActiveLearning(ActiveLearning):
    def next(self, strategy, images):
        return super().next(strategy, images)
