import re

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

# Function to convert Camel Case to Snake Case
def camel_to_snake(column_name):
    return re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', column_name).lower()

@transformer
def transform(final_quarter_data, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your transformation logic here
    print(final_quarter_data)

    # Remove rows where passenger count or trip distance is equal to zero
    final_quarter_data = final_quarter_data[(final_quarter_data['passenger_count'] > 0) & (final_quarter_data['trip_distance'] > 0)]

    # Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date
    final_quarter_data['lpep_pickup_date'] = final_quarter_data['lpep_pickup_datetime'].dt.date

    # Rename columns in Camel Case to Snake Case
    final_quarter_data.columns = [camel_to_snake(col) for col in final_quarter_data.columns]

    print(final_quarter_data.shape)
    # Assuming 'final_quarter_data' is your DataFrame
    num_categories = final_quarter_data['vendor_id'].nunique()

    print(f'The number of unique categories in the "vendor_id" column is: {num_categories}')

    return final_quarter_data

@test
def test_output(final_quarter_data, *args) -> None:
    """
    Template code for testing the output of the block.
    """

    # Assertions
    assert final_quarter_data['vendor_id'].isin(final_quarter_data['vendor_id']).all(), "Assertion Error: vendor_id is not one of the existing values."
    assert (final_quarter_data['passenger_count'] > 0).all(), "Assertion Error: passenger_count is not greater than 0."
    assert (final_quarter_data['trip_distance'] > 0).all(), "Assertion Error: trip_distance is not greater than 0."

    assert final_quarter_data is not None, 'The output is undefined'
