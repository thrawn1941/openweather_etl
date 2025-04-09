from transform.abstract_transform_strategy import TransformDataStrategy

class Transform:
    id_list = []

    def __init__(self, data, transform_strategy: TransformDataStrategy):
        self.transform_strategy = transform_strategy
        self.data = data

        self.id = 0 if len(Transform.id_list) == 0 else max(Transform.id_list) + 1
        Transform.id_list.append(self.id)

    def return_data_for_bigquery(self):
        return self.transform_strategy.transform_data()

    def print_data_schema(self):
        self.transform_strategy.print_schema()