from transform.abstract_transform_strategy import TransformDataStrategy
import asyncio

class Transform:
    id_list = []

    def __init__(self, data, transform_strategy: TransformDataStrategy):
        self.data = data
        self.transform_strategy = transform_strategy
        self.collected_data = dict()
        self.id = 0 if len(Transform.id_list) == 0 else max(Transform.id_list) + 1
        Transform.id_list.append(self.id)