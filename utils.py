from google.cloud import pubsub_v1

def get_cities_from_config() -> list[str]:
    cities = []
    with open("config/config_cities", "r", encoding="utf-8") as f:
        for line in f:
            cities.append(line.strip())
    return cities

def string_data_to_timestamp_unix(data: str) -> int:
    from datetime import datetime, timezone
    """
    Convert a date string in dd/mm/yyyy format to Unix timestamp (UTC).

    :param data: Date string in the format "dd/mm/yyyy".
    :return: Corresponding Unix timestamp as an integer.
    """
    return int(datetime.strptime(data, "%d/%m/%Y").replace(tzinfo=timezone.utc).timestamp())

def publish_message(data, target_topic):
    try:
        publisher = pubsub_v1.PublisherClient()
        future = publisher.publish(target_topic, data.encode(encoding="utf-8"))
        future.result()
    except Exception as e:
        print(f"Error: {e}")