from transform.abstract_transform_strategy import TransformDataStrategy

class GeoTransformStrategy(TransformDataStrategy):

    def fake_transform(self):
        pass

    def get_lon_lat(self):
        return self.data['coord']