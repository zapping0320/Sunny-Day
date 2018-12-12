//
//  AirPollution.swift
//  YJWeather
//
//  Created by 최영준 on 2018. 9. 28..
//  Copyright © 2018년 최영준. All rights reserved.
//

import Foundation
import SwiftyJSON

class AirPollution {
    // MARK: - Custom enumerations
    // MARK: -
    /// 대기오염 타입: 근접 측정소, 실시간 측정정보
    enum AirPollutionType {
        case measuringStation
        case realtime
    }
    /// 실시간 측정정보 카테고리
    private enum RealtimeCategoryType {
        case dataTime, mangName, so2Value, coValue, o3Value, no2Value, pm10Value, pm10Value24, pm25Value, pm25Value24, khaiValue, khaiGrade, so2Grade, coGrade, o3Grade, no2Grade, pm10Grade, pm25Grade, pm10Grade1h, pm25Grade1h
    }
    
    // MARK: - Custom methods
    // MARK: -
    /// 데이터를 추출하여 변환후 반환한다
    func extractData(_ type: AirPollutionType, data: Data?) -> Any? {
        do {
            let responseJson = try JSON(data: data!)
            let items = responseJson["list"]
            
            switch type {
            case .measuringStation:
                return extractMeasuringStationData(items)
            case .realtime:
                var data = extractRealtimeData(items)
                let stationName = responseJson["ArpltnInforInqireSvcVo"]["stationName"].stringValue
                data?.stationName = stationName
                return data
                
            }
        }
        catch {
            return nil
        }
    }
    /// 근접 측정소 목록에서 stationName 목록을 추출하여 반환한다
    //private func extractMeasuringStationData(_ data: Any?) -> Any? {
    private func extractMeasuringStationData(_ items: JSON) -> Any? {
        let itemlist: Array<JSON> = items.arrayValue
        var stationNames = [String]()
        for item in itemlist {
            // 보통 3개의 측정소 이름이 존재한다
            //for item in items {
            let stationName = item["stationName"].stringValue
            stationNames.append(stationName)
        }
        return stationNames
        
    }
    /// 측정소별 실시간 측정정보를 추출하여 반환한다
    //private func extractRealtimeData(_ data: Any?) -> AirPollutionData? {
    private func extractRealtimeData(_ items: JSON) -> AirPollutionData? {
        let itemlist: Array<JSON> = items.arrayValue
        guard let item  = itemlist.first else
        {
            return nil
        }
        var airPollution = AirPollutionData()
        for (key, value) in item {
            switch key {
            case "dataTime":
                airPollution.dataTime = convertToString(.dataTime, value: value)
            case "mangName":
                airPollution.mangName = convertToString(.mangName, value: value)
            case "so2Value":
                airPollution.so2Value = convertToString(.so2Value, value: value)
            case "coValue":
                airPollution.coValue = convertToString(.coValue, value: value)
            case "o3Value":
                airPollution.o3Value = convertToString(.o3Value, value: value)
            case "no2Value":
                airPollution.no2Value = convertToString(.no2Value, value: value)
            case "pm10Value":
                airPollution.pm10Value = convertToString(.pm10Value, value: value)
            case "pm10Value24":
                airPollution.pm10Value24 = convertToString(.pm10Value24, value: value)
            case "pm25Value":
                airPollution.pm25Value = convertToString(.pm25Value, value: value)
            case "pm25Value24":
                airPollution.pm25Value24 = convertToString(.pm25Value24, value: value)
            case "khaiValue":
                airPollution.khaiValue = convertToString(.khaiValue, value: value)
            case "khaiGrade":
                airPollution.khaiGrade = convertToString(.khaiGrade, value: value)
            case "so2Grade":
                airPollution.so2Grade = convertToString(.so2Grade, value: value)
            case "coGrade":
                airPollution.coGrade = convertToString(.coGrade, value: value)
            case "o3Grade":
                airPollution.o3Grade = convertToString(.o3Grade, value: value)
            case "no2Grade":
                airPollution.no2Grade = convertToString(.no2Grade, value: value)
            case "pm10Grade":
                airPollution.pm10Grade = convertToString(.pm10Grade, value: value)
            case "pm25Grade":
                airPollution.pm25Grade = convertToString(.pm25Grade, value: value)
            case "pm10Grade1h":
                airPollution.pm10Grade1h = convertToString(.pm10Grade1h, value: value)
            case "pm25Grade1h":
                airPollution.pm25Grade1h = convertToString(.pm25Grade1h, value: value)
            default:
                ()
            }
        }
        return airPollution
    }
    /// 추출한 데이터를 문자열로 변환한다
    private func convertToString(_ type: RealtimeCategoryType, value: Any) -> String {
        var result = ""
        switch type {
        case .dataTime, .mangName, .khaiValue:
            result = "\(value)"
        case .so2Value, .coValue, .o3Value, .no2Value:
            result = ("\(value)" == "-") ? "-" : "\(value)ppm"
        case .pm10Value, .pm10Value24, .pm25Value, .pm25Value24:
            result = ("\(value)" == "-") ? "-" : "\(value)㎍/㎥"
        case .khaiGrade, .so2Grade, .coGrade, .o3Grade, .no2Grade, .pm10Grade, .pm25Grade, .pm10Grade1h, .pm25Grade1h:
            let grade = "\(value)"
            if grade == "1" {
                result = "좋음"
            } else if grade == "2" {
                result = "보통"
            } else if grade == "3" {
                result = "나쁨"
            } else if grade == "4" {
                result = "매우나쁨"
            } else {
                result = "정보없음"
            }
        }
        return result
    }
}
