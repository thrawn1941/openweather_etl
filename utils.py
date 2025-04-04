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

def publish_message(api_key, data, target_topic):
    publisher = pubsub_v1.PublisherClient.from_service_account_file(API_KEY)
    #topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)
    topic_path = publisher.topic_path("totemic-client-447220-r1", LAST_MONTH_TOPIC_ID)

    msg = publisher.publish(topic_path, data)
    print(f"Message send: {msg.result()}")