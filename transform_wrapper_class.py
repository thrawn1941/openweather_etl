from transform.abstract_transform_strategy import TransformDataStrategy

class Transform:
    id_list = []

    def __init__(self, data, transform_strategy: TransformDataStrategy):
        self.transform_strategy = transform_strategy
        if type(data) is dict:
            if len(data) < 1:
                raise Exception('Empty dict provided!')
            else:
                self.data = data
        else:
            raise Exception('Data provided in wrong format! It should be dict.')

        self.id = 0 if len(Transform.id_list) == 0 else max(Transform.id_list) + 1
        Transform.id_list.append(self.id)

    def return_data_for_bigquery(self):
        return self.transform_strategy.transform_data(self.data)

    def print_data_schema(self):
        self.transform_strategy.print_schema(self.data)