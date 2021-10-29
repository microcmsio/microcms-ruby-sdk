# frozen_string_literal: true

require 'microcms'

RSpec::Matchers.define :request do |method, path, headers, body|
  match do |actual|
    hash = {
      method: [method, actual.method],
      path: [path, actual.path],
      headers: [headers, headers.map { |k, _v| [k, actual[k]] }.to_h],
      body: [body, actual.body]
    }
    hash.all? { |_k, v| v[0] == v[1] }
  end
end

describe MicroCMS do
  let(:client) { MicroCMS::Client.new('service-domain', 'api-key') }

  let(:content) do
    {
      id: 'foo',
      text: 'Hello, microCMS!',
      createdAt: '2021-10-28T07:51:30.668Z',
      updatedAt: '2021-10-28T08:06:05.385Z',
      publishedAt: '2021-10-28T07:51:30.668Z',
      revisedAt: '2021-10-28T08:06:05.385Z'
    }
  end

  let(:content_list) do
    {
      contents: [content],
      totalCount: 1,
      limit: 10,
      offset: 0
    }
  end

  let(:expected_req_method) { 'GET' }

  let(:expected_req_path) { '/api/v1/endpoint' }

  let(:expected_req_headers) { { 'x-microcms-api-key' => 'api-key' } }

  let(:expected_req_body) { nil }

  let(:req_matcher) { request(expected_req_method, expected_req_path, expected_req_headers, expected_req_body) }

  let(:mock_res_headers) { { 'Content-Type' => 'application/json' } }

  let(:mock_res_body) { JSON.dump(content_list) }

  let(:mock_response) do
    response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    mock_res_headers.each { |k, v| response[k] = v }
    response
  end

  context 'When send GET request without content id' do
    it 'should return contents' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.list('endpoint')

      expect(res.contents).to eq [OpenStruct.new(content)]
    end
  end

  context 'When send GET request with content id' do
    let(:expected_req_path) { '/api/v1/endpoint/foo' }

    let(:mock_res_body) { JSON.dump(content) }

    it 'should return content' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.get('endpoint', 'foo')

      expect(res).to eq OpenStruct.new(content)
    end
  end

  context 'When send POST request' do
    let(:expected_req_method) { 'POST' }
    let(:expected_req_body) { JSON.dump({ text: 'Hello, new content!' }) }

    let(:mock_res_body) { JSON.dump(content) }
    let(:mock_res_body) { '{"id": "bar"}' }

    it 'should return id' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.create('endpoint', { text: 'Hello, new content!' })

      expect(res).to eq OpenStruct.new({ id: 'bar' })
    end
  end

  context 'When send PUT request' do
    let(:expected_req_method) { 'PUT' }
    let(:expected_req_path) { '/api/v1/endpoint/bar' }
    let(:expected_req_body) { JSON.dump({ text: 'Hello, new content!' }) }

    let(:mock_res_body) { JSON.dump(content) }
    let(:mock_res_body) { '{"id": "bar"}' }

    it 'should return id' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.create('endpoint', { id: 'bar', text: 'Hello, new content!' })

      expect(res).to eq OpenStruct.new({ id: 'bar' })
    end
  end

  context 'When send POST request with draft status' do
    let(:expected_req_method) { 'POST' }
    let(:expected_req_path) { '/api/v1/endpoint?status=draft' }
    let(:expected_req_body) { JSON.dump({ text: 'Hello, new content!' }) }

    let(:mock_res_body) { JSON.dump(content) }
    let(:mock_res_body) { '{"id": "bar"}' }

    it 'should return id' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.create('endpoint', { text: 'Hello, new content!' }, { status: 'draft' })

      expect(res).to eq OpenStruct.new({ id: 'bar' })
    end
  end

  context 'When send PATCH request' do
    let(:expected_req_method) { 'PATCH' }
    let(:expected_req_path) { '/api/v1/endpoint/bar' }
    let(:expected_req_body) { JSON.dump({ text: 'Hello, new content!' }) }

    let(:mock_res_body) { JSON.dump(content) }
    let(:mock_res_body) { '{"id": "bar"}' }

    it 'should return id' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }
      expect(mock_response).to receive(:body) { mock_res_body }

      res = client.update('endpoint', { id: 'bar', text: 'Hello, new content!' })

      expect(res).to eq OpenStruct.new({ id: 'bar' })
    end
  end

  context 'When send PATCH request' do
    let(:expected_req_method) { 'DELETE' }
    let(:expected_req_path) { '/api/v1/endpoint/bar' }

    let(:mock_res_body) { nil }
    let(:mock_res_headers) { { 'Content-Type': 'text/plain' } }

    it 'should return id' do
      expect_any_instance_of(Net::HTTP).to receive(:request).with(req_matcher) { mock_response }

      client.delete('endpoint', 'bar')
    end
  end
end
